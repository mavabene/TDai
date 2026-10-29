
(********************** Declaration ****************************)
METHOD cycleTimeTracking
VAR_INPUT
END_VAR
VAR
	CL: INT;
	CAT: INT;
	RM: INT;
	TMP: INT;
END_VAR
(********************** Implementation ****************************)
(* This all starts when we transition into track mode, in automatic.  This causes the closing of the previous temporary file,
	if necessary, concatenation of that open file onto the end of the file holding the entire days results, then
	opening the temporary file for write. *)

// CYCLE_STEP_LOCAL := CYCLE_STEP;

// If we are done writing the last file and need a new temporary file open.
IF NOT EXEC_02.xExecute AND FH_CYCLE = RTS_INVALID_HANDLE THEN
	// File is not open.  Open on a mode change into track mode.
	IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_TRACK THEN
		// Make the name for the temporary file, then open and truncate if necessary.
		ConstructFilename(pFILENAME := ADR(TEMPORARY_FILENAME), SCREW_ID := 'z', SOURCE_ID := '2', INCLUDE_HH_MM_SS := TRUE);
		TEMPORARY_FILENAME := CONCAT('/home/Ojjo/data/', TEMPORARY_FILENAME);
		
		FH_CYCLE := SysFileOpen(szFile := TEMPORARY_FILENAME, am := ACCESS_MODE.AM_WRITE, pResult := ADR(ERROR_OPEN));
		START_TIME_SECONDS := RECEIVE_1.TIME_SECONDS_FLOAT;
		ELAPSED_TIME_SECONDS := 0.0;

		writeCycleHeader(FH_CYCLE);
		writeCycleMessage103(FH_CYCLE, CYCLE_STEP_LOCAL, CYCLE_DATA, CYCLE_SCREW, CYCLE_SIDE, CYCLE_TRUSS);

		PLC_PRG.manageUplinkData_01.bufferCycleTime(0, 0, 0, 0, 0);
		PLC_PRG.manageUplinkData_01.bufferCycleTime(CYCLE_STEP_LOCAL, CYCLE_DATA, CYCLE_SCREW, CYCLE_SIDE, CYCLE_TRUSS);
	ELSE
		// Do nothing, just wait to get to cycle step 1.
		;
	END_IF
ELSIF NOT EXEC_02.xExecute THEN
	// Automatic, and file is open.  Look for state changes and write reports as indicated.
	ELAPSED_TIME_SECONDS := RECEIVE_1.TIME_SECONDS_FLOAT - START_TIME_SECONDS;
	IF IS_NEW_CYCLE_STEP THEN
		IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_TRACK THEN
			(* We're started a new cycle.  If the temporary file is open, close it and concat to the USB file.  Then mark the
				temporary file as closed and let the code above reopen it. *)
			IF FH_CYCLE <> RTS_INVALID_HANDLE THEN
				// First, close out the cycle time calculation.
				writeCycleMessage103(FH_CYCLE, 0, 0, 0, 0, 0);

				PLC_PRG.manageUplinkData_01.bufferCycleTime(255, 0, 0, 0, 0);

				SysFileClose(hFile := FH_CYCLE);
				FH_CYCLE := RTS_INVALID_HANDLE;

				(* Do we have a USB drive attached? *)
				USB_01(xEnable := TRUE, eDiagInfo => DIAG_INFO);
				
				IF USB_01.usiNumOfUSBdevice = 1 THEN
					ConstructFilename(pFILENAME := ADR(CYCLE_TIME_FILENAME), SCREW_ID := 'z', SOURCE_ID := '2', INCLUDE_HH_MM_SS := FALSE);
					COMMAND_CYCLE := '';
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, 'cat ');
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, TEMPORARY_FILENAME);
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, ' >> ');
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, USB_01.sAccessPath);
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, '/');
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, DIRECTORY_CYCLE_TIME);
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, '/');
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, CYCLE_TIME_FILENAME);
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, '; rm ');
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, TEMPORARY_FILENAME);
				ELSE
					(* No USB, just delete the temporary file. *)	
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, 'rm ');
					COMMAND_CYCLE := CONCAT(COMMAND_CYCLE, TEMPORARY_FILENAME);
				END_IF;
				
				prepLinuxAsync(ADR(EXEC_02), ADR(USB_TON_02), COMMAND_CYCLE, T#30S); // RE execute gets turned on
			END_IF
		ELSE
			writeCycleMessage103(FH_CYCLE, CYCLE_STEP_LOCAL, CYCLE_DATA, CYCLE_SCREW, CYCLE_SIDE, CYCLE_TRUSS);

			PLC_PRG.manageUplinkData_01.bufferCycleTime(CYCLE_STEP_LOCAL, CYCLE_DATA, CYCLE_SCREW, CYCLE_SIDE, CYCLE_TRUSS);
		END_IF
	END_IF
END_IF

//CYCLE_STEP_LAST := CYCLE_STEP_LOCAL;

// Always run this, to be sure it executes to completion even when the code above changes state
//	for operational reasons.
ASYNC_02(pASYNC := ADR(EXEC_02), pTON := ADR(USB_TON_02), wCmdOut => CMD2_RESULT); /// if execute turned on will execute linux command
IF CMD2_RESULT <> 0 THEN
	CMD2_LAST_FAIL := CMD2_RESULT;
END_IF

