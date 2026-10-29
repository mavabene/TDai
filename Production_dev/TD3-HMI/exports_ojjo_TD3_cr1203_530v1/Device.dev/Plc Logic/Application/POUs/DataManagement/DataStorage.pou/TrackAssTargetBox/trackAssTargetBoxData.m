
(********************** Declaration ****************************)
METHOD trackAssTargetBoxData
VAR_INPUT
END_VAR
VAR

END_VAR

(********************** Implementation ****************************)
(* Collect gps offsets and actuator positions before and after targeting to find out how much they moved.  This will tell us how close the target is getting with Track Assist *)
IF FH_TA_ACC_DATA = 0 THEN 
	FH_TA_ACC_DATA := RTS_INVALID_HANDLE;
END_IF

// prep and wait stage - do this upon entering track ie IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_TRACK THEN
(* Open a new temporary file if async is idle and file is not already open *)
IF NOT EXEC_TA_ACC_DATA.xExecute AND FH_TA_ACC_DATA = RTS_INVALID_HANDLE THEN
	// File is not open.  Open on a mode change into track mode.
	IF (MACHINE_MODE_TRANSMIT = TRACK_MODE) OR (DEBUG_TEST_INT = 15 AND DEBUG_TEST_INT_LAST_AB <> DEBUG_TEST_INT) THEN
// 	IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_TRACK OR DEBUG_TEST_INT = 5 THEN
		// Make the name for the temporary file, then open and truncate if necessary.
		DEBUG_TEST_INT_LAST_AB := DEBUG_TEST_INT; // debug
		ConstructFilename(
			pFILENAME := ADR(TEMPORARY_FILENAME_TA_ACC),
			SCREW_ID := 'x',
			SOURCE_ID := '4',
			INCLUDE_HH_MM_SS := FALSE
		);
		TEMPORARY_FILENAME_TA_ACC := CONCAT('/home/Ojjo/data/', TEMPORARY_FILENAME_TA_ACC);
	
		FH_TA_ACC_DATA := SysFileOpen(
			szFile := TEMPORARY_FILENAME_TA_ACC,
			am := ACCESS_MODE.AM_WRITE,
			pResult := ADR(ERROR_OPEN)
		);
		
		// write one header per position
		IF FH_TA_ACC_DATA <> RTS_INVALID_HANDLE THEN
			writeTrackAssDataHeader();
		END_IF
	ELSE
		// Do nothing, just wait to get to cycle step 1.
		;
	END_IF
	
ELSIF NOT EXEC_TA_ACC_DATA.xExecute THEN	
	// Automatic, and file is open.  Look for state changes and write reports as indicated.
	IF IS_NEW_MACHINE_MODE 
// 	IF IS_NEW_CYCLE_STEP 
		OR  ((DEBUG_TEST_INT = 17 OR DEBUG_TEST_INT = 16) AND DEBUG_TEST_INT_LAST <> DEBUG_TEST_INT) THEN
		DEBUG_TEST_INT_LAST := 	DEBUG_TEST_INT; 
		IF (MACHINE_MODE_TRANSMIT = RWP_MODE) OR DEBUG_TEST_INT = 16 THEN // we don't want to rewrite every time an operator goes man/auto!
// 		IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_RWP OR DEBUG_TEST_INT = 6 THEN
			(* Collect GPS offsets to target and TA utilization flag *)
			writeTrackAssDataMessage_1();
		ELSIF (MACHINE_MODE_TRANSMIT = SCREW_MODE) OR DEBUG_TEST_INT = 17 THEN
// 		ELSIF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_SCREW OR DEBUG_TEST_INT = 7 THEN
			(* We're ending a TA_ACC data collection cycle. If the temporary file is open, close it and concat to the USB file.  Then mark the
				temporary file as closed and let the code above reopen it when entering track mode. *)
			DEBUG_TEST_INT_LAST :=	DEBUG_TEST_INT;
			writeTrackAssDataMessage_2();
			
			SysFileClose(hFile := FH_TA_ACC_DATA);
			FH_TA_ACC_DATA := RTS_INVALID_HANDLE;
			
			(* Do we have a USB drive attached? *)
			USB_01(xEnable := TRUE, eDiagInfo => DIAG_INFO);
			
			IF USB_01.usiNumOfUSBdevice = 1 THEN
				ConstructFilename(pFILENAME := ADR(TA_ACC_DATA_FILENAME), SCREW_ID := 'x', SOURCE_ID := '4', INCLUDE_HH_MM_SS := FALSE);
				
				COMMAND_TA_ACC_DATA := '';
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, 'cat ');
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, TEMPORARY_FILENAME_TA_ACC);
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, ' >> ');
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, USB_01.sAccessPath);
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, '/');
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, DIRECTORY_TA_DATA);
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, '/');
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, TA_ACC_DATA_FILENAME);
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, ' && sync && rm -f ');
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, TEMPORARY_FILENAME_TA_ACC);
			ELSE
				(* No USB present, just remove temp file *)
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, 'rm ');
				COMMAND_TA_ACC_DATA := CONCAT(COMMAND_TA_ACC_DATA, TEMPORARY_FILENAME_TA_ACC);
			END_IF;
			
			// RE execute gets turned on
			prepLinuxAsync(
				pASYNC := ADR(EXEC_TA_ACC_DATA),
				pTON := ADR(USB_TON_TA_ACC_DATA),
				CMD := COMMAND_TA_ACC_DATA,
				TIMEOUT := T#30S
			);
		END_IF
	END_IF	
END_IF

(* Always run async executor *)
ASYNC_TA_ACC_DATA(
	pASYNC := ADR(EXEC_TA_ACC_DATA),
	pTON := ADR(USB_TON_TA_ACC_DATA),
	wCmdOut => CMD_TA_ACC_DATA_RESULT);
IF CMD_TA_ACC_DATA_RESULT <> 0 THEN
	CMD_TA_ACC_DATA_LAST_FAIL := CMD_TA_ACC_DATA_RESULT;
END_IF
