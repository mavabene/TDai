
(********************** Declaration ****************************)
METHOD FoundationAsBuilt
VAR_INPUT
END_VAR
VAR

END_VAR


(********************** Implementation ****************************)
(* vvvvvvvvvvvvvvvvvvvvvvvvvvv Data Streaming vvvvvvvvvvvvvvvvvvvvvvvvvvv *)

IF xAsBuiltScrewReadyForQueue THEN
    IF DataUplink.EnqueueMessage22_AsBuiltScrew(
        stScrew := stAsBuiltActiveScrew
    ) THEN
        xAsBuiltScrewReadyForQueue := FALSE;
        xAsBuiltActiveScrewValid := FALSE;
		numScrewMsgsSent := numScrewMsgsSent + 1;
    ELSE
        udiAsBuiltScrewEnqueueFailures :=
            udiAsBuiltScrewEnqueueFailures + 1;
		numScrewMsgsSendFails := numScrewMsgsSendFails + 1;
    END_IF
END_IF

IF xAsBuiltFoundationReadyForQueue THEN
    IF DataUplink.EnqueueMessage21_AsBuiltLocating(
        stFoundation := stAsBuiltFoundation
    ) THEN
        xAsBuiltFoundationReadyForQueue := FALSE;
		numAsBuiltMsgsSent := numAsBuiltMsgsSent + 1;
    ELSE
        udiAsBuiltFoundationEnqueueFailures :=
            udiAsBuiltFoundationEnqueueFailures + 1;
		numAsBuiltMsgsSendFails := numAsBuiltMsgsSendFails + 1;
    END_IF
END_IF
(* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Data Streaming ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ *)



(* Collect gps offsets and actuator positions before and after targeting to find out how much they moved.  This will tell us how close the target is getting with Track Assist *)
IF FH_GPS_AB = 0 THEN 
	FH_GPS_AB := RTS_INVALID_HANDLE;
END_IF


// prep and wait stage - do this upon entering track ie IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_TRACK THEN
(* Open a new temporary file if async is idle and file is not already open *)
IF NOT EXEC_GPS_AB.xExecute AND FH_GPS_AB = RTS_INVALID_HANDLE THEN
	// File is not open.  Open on a mode change into track mode.
	
	IF (MACHINE_MODE_TRANSMIT = SCREW_MODE AND SCREW_STATE_TRANSMIT = SCREW_STATE_FWP) OR (DEBUG_TEST_INT = 5 AND DEBUG_TEST_INT_LAST_AB <> DEBUG_TEST_INT) THEN
	//IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_LOCATE_FWP OR DEBUG_TEST_INT = 5 THEN // don't use cycle steps for this, if we change cycle steps this breaks!
		// Make the name for the temporary file, then open and truncate if necessary.
		
		ConstructFilename(
			pFILENAME := ADR(TEMPORARY_FILENAME_GPS),
			SCREW_ID := 'x',
			SOURCE_ID := '3',
			INCLUDE_HH_MM_SS := FALSE
		);
		TEMPORARY_FILENAME_GPS := CONCAT('/home/Ojjo/data/', TEMPORARY_FILENAME_GPS);
	
		FH_GPS_AB := SysFileOpen(
			szFile := TEMPORARY_FILENAME_GPS,
			am := ACCESS_MODE.AM_WRITE,
			pResult := ADR(ERROR_OPEN)
		);
		
		IF FH_GPS_AB <> RTS_INVALID_HANDLE THEN
			writeFoundationAsBuiltHeader();
			DEBUG_TEST_INT_LAST_AB := DEBUG_TEST_INT; // debug
		END_IF
	ELSE
		// Do nothing, just wait to get to cycle step 1.
		;
	END_IF
	
ELSIF NOT EXEC_GPS_AB.xExecute THEN	
	// Automatic, and file is open.  Look for state changes and write reports as indicated.

	IF (DEBUG_TEST_INT = 6 AND DEBUG_TEST_INT_LAST_AB <> DEBUG_TEST_INT) OR
	(IS_NEW_MACHINE_STATE AND MACHINE_MODE_TRANSMIT = SCREW_MODE AND SCREW_STATE_TRANSMIT = SCREW_STATE_CRIMP) THEN 
	// 		IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_CRIMP OR DEBUG_TEST_INT = 6 THEN
		(* Collect GPS offsets to target and TA utilization flag *)
		DEBUG_TEST_INT_LAST_AB := DEBUG_TEST_INT; // debug
		WAS_CRIMPED_IN_AUTO := TRUE;// set crimp auto flag true, gets changed to false if manual entered at any point.
		writeFoundationAsBuiltMessage(CRIMPED := FALSE);
	ELSIF TRUSS_COMPLETED OR (DEBUG_TEST_INT = 7 AND DEBUG_TEST_INT_LAST_AB <> DEBUG_TEST_INT) THEN
	// 		ELSIF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_TRACK OR DEBUG_TEST_INT = 7 THEN
		(* We're ending a TA_ACC data collection cycle. If the temporary file is open, close it and concat to the USB file.  Then mark the
			temporary file as closed and let the code above reopen it when entering track mode. *)
		DEBUG_TEST_INT_LAST_AB := DEBUG_TEST_INT; // debug
		writeFoundationAsBuiltMessage(CRIMPED := TRUE);
	
		SysFileClose(hFile := FH_GPS_AB);
		FH_GPS_AB := RTS_INVALID_HANDLE;
		
		(* Do we have a USB drive attached? *)
		USB_01(xEnable := TRUE, eDiagInfo => DIAG_INFO);
		
		IF USB_01.usiNumOfUSBdevice = 1 THEN
			ConstructFilename(pFILENAME := ADR(GPS_AB_FILENAME), SCREW_ID := 'x', SOURCE_ID := '3', INCLUDE_HH_MM_SS := FALSE);
			
			COMMAND_GPS_AB := '';
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, 'cat ');
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, TEMPORARY_FILENAME_GPS);
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, ' >> ');
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, USB_01.sAccessPath);
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, '/');
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, DIRECTORY_GPS_AB_DATA);
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, '/');
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, GPS_AB_FILENAME);
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, ' && sync && rm -f ');
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, TEMPORARY_FILENAME_GPS);
		ELSE
			(* No USB present, just remove temp file *)
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, 'rm ');
			COMMAND_GPS_AB := CONCAT(COMMAND_GPS_AB, TEMPORARY_FILENAME_GPS);
		END_IF;
		// RE execute gets turned on
		prepLinuxAsync(
			pASYNC := ADR(EXEC_GPS_AB),
			pTON := ADR(USB_TON_GPS_AB),
			CMD := COMMAND_GPS_AB,
			TIMEOUT := T#30S
		);
	END_IF
END_IF

IF 	MACHINE_MODE_TRANSMIT = SCREW_MODE AND MANUAL_TRANSMIT THEN
	WAS_CRIMPED_IN_AUTO := FALSE;
END_IF

//DEBUG_TEST_INT_LAST_AB := DEBUG_TEST_INT;

(* Always run async executor *)
ASYNC_GPS_AB(
	pASYNC := ADR(EXEC_GPS_AB),
	pTON := ADR(USB_TON_GPS_AB),
	wCmdOut => CMD_GPS_RESULT);
IF CMD_GPS_RESULT <> 0 THEN
	CMD_GPS_LAST_FAIL := CMD_GPS_RESULT;
END_IF

