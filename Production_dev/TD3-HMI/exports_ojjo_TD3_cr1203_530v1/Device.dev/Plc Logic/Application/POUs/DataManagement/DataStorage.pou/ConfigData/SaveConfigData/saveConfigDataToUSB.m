
(********************** Declaration ****************************)
METHOD saveConfigDataToUSB
VAR_INPUT
END_VAR
VAR
	CONFIG_TYPE: STRING;
END_VAR


(********************** Implementation ****************************)
(* Collect gps offsets and actuator positions before and after targeting to find out how much they moved.  This will tell us how close the target is getting with Track Assist *)
IF FH_CONFIG_DATA = 0 THEN 
	FH_CONFIG_DATA := RTS_INVALID_HANDLE;
END_IF

(* Open a new temporary file if async is idle and file is not already open *)
IF FH_CONFIG_DATA = RTS_INVALID_HANDLE AND NOT EXEC_CONFIG_DATA.xExecute THEN
	// Open file
	CHECK_FILE_WRITTEN := FALSE;
	USB_CONFIG_FILE_RESULT := 86;
	IF CONFIG_WRITE_TO_USB THEN
	//IF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_LOCATE_FWP OR DEBUG_TEST_INT = 5 THEN // don't use cycle steps for this, if we change cycle steps this breaks!
		// Make the name for the temporary file, then open and truncate if necessary.
		FILE_WRITE_BUSY := TRUE;
		ConstructFilename(
			pFILENAME := ADR(TEMPORARY_FILENAME_CONFIG_DATA),
			SCREW_ID := 'x',
			SOURCE_ID := '5',
			INCLUDE_HH_MM_SS := FALSE
		);
		
		TEMPORARY_FILENAME_CONFIG_DATA := CONCAT('/home/Ojjo/data/', TEMPORARY_FILENAME_CONFIG_DATA);
	
		FH_CONFIG_DATA := SysFileOpen(
			szFile := TEMPORARY_FILENAME_CONFIG_DATA,
			am := ACCESS_MODE.AM_WRITE,
			pResult := ADR(ERROR_OPEN)
		);
		IF FH_CONFIG_DATA = RTS_INVALID_HANDLE
			OR ERROR_OPEN <> 0 THEN
		
			FILE_WRITE_BUSY := FALSE;
			CONFIG_WRITE_TO_USB := FALSE;
			ASYNC_EXECUTING := FALSE;
			USB_READ_WRITE_VALID := FALSE;
		
			Data_Handling.CONFIG_STATUS_MSG :=
				'Could not open local configuration file';
		
			RETURN;
		END_IF;
		// Do nothing, just wait to get to cycle step 1.
		;
	END_IF
	
ELSIF NOT EXEC_CONFIG_DATA.xExecute THEN	
	// Automatic, and file is open.  Look for state changes and write reports as indicated.
	IF CONFIG_WRITE_TO_USB THEN

		CASE Data_Handling.CONFIG_FILE_TYPE OF
	
			eConfigFileType.DrillSpecificSettings: writeConfigDrillSettingsMessage();
			
			eConfigFileType.JobSpecificSettings: writeConfigJobSettingsMessage();
			
			eConfigFileType.GeneralSettings: writeConfigGeneralSettingsMessage();
			
			eConfigFileType.MachineSpecificSettings: writeConfigMachineSpecificMessage();
				
		END_CASE
		
		CONFIG_WRITE_TO_USB := FALSE;
		ASYNC_EXECUTING := FALSE;
	ELSE
	// 		ELSIF CYCLE_STEP_LOCAL = eCycleSteps.CYCLE_STEP_ENTER_TRACK OR DEBUG_TEST_INT = 7 THEN
		(* We're ending a TA_ACC data collection cycle. If the temporary file is open, close it and concat to the USB file.  Then mark the
			temporary file as closed and let the code above reopen it when entering track mode. *)
		DEBUG_TEST_INT_LAST_AB := DEBUG_TEST_INT; // debug
		
		SysFileClose(hFile := FH_CONFIG_DATA);
		FH_CONFIG_DATA := RTS_INVALID_HANDLE;
		
		(* Do we have a USB drive attached? *)
		USB_01(xEnable := TRUE, eDiagInfo => DIAG_INFO);
		
		IF USB_01.usiNumOfUSBdevice = 1 THEN
			CASE Data_Handling.CONFIG_FILE_TYPE OF
				eConfigFileType.DrillSpecificSettings:
					CONFIG_TYPE := 'DRILL_SETTINGS';
				eConfigFileType.JobSpecificSettings:
					CONFIG_TYPE := 'JOB_SETTINGS';
				eConfigFileType.MachineSpecificSettings:
					CONFIG_TYPE := 'TD_SPECIFIC_SETTINGS';
				eConfigFileType.GeneralSettings:
					CONFIG_TYPE := 'GENERAL_SETTINGS';
			END_CASE

			ConstructFilename(pFILENAME := ADR(CONFIG_DATA_FILENAME), SCREW_ID := CONFIG_TYPE, SOURCE_ID := '5', INCLUDE_HH_MM_SS := FALSE);
			
			COMMAND_CONFIG_DATA := '';
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, 'cat ');
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, TEMPORARY_FILENAME_CONFIG_DATA);
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, ' > ');
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, USB_01.sAccessPath);
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, '/');
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, DIRECTORY_CONFIG_DATA);
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, '/');
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, CONFIG_DATA_FILENAME);
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, ' && sync && rm -f ');
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, TEMPORARY_FILENAME_CONFIG_DATA);
			ASYNC_EXECUTING := TRUE;
			TEMPORARY_FILENAME_CONFIG_DATA := USB_01.sAccessPath;
			TEMPORARY_FILENAME_CONFIG_DATA := CONCAT(TEMPORARY_FILENAME_CONFIG_DATA, '/');
			TEMPORARY_FILENAME_CONFIG_DATA := CONCAT(TEMPORARY_FILENAME_CONFIG_DATA, DIRECTORY_CONFIG_DATA);
			TEMPORARY_FILENAME_CONFIG_DATA := CONCAT(TEMPORARY_FILENAME_CONFIG_DATA, '/');
			TEMPORARY_FILENAME_CONFIG_DATA := CONCAT(TEMPORARY_FILENAME_CONFIG_DATA, CONFIG_DATA_FILENAME);
		ELSE
			(* No USB present. *)
			FILE_WRITE_BUSY := FALSE;
			CONFIG_WRITE_TO_USB := FALSE;
			ASYNC_EXECUTING := FALSE;
			USB_READ_WRITE_VALID := FALSE;
		
			Data_Handling.CONFIG_STATUS_MSG :=
				'No USB found';
	
			(* No USB present, just remove temp file *)
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, 'rm ');
			COMMAND_CONFIG_DATA := CONCAT(COMMAND_CONFIG_DATA, TEMPORARY_FILENAME_CONFIG_DATA);
			RETURN;
		END_IF;
		// RE execute gets turned on
		prepLinuxAsync(
			pASYNC := ADR(EXEC_CONFIG_DATA),
			pTON := ADR(USB_TON_CONFIG_DATA),
			CMD := COMMAND_CONFIG_DATA,
			TIMEOUT := T#30S
		);
	END_IF
END_IF

(* Always run async executor *)
ASYNC_CONFIG_DATA(
	pASYNC := ADR(EXEC_CONFIG_DATA),
	pTON := ADR(USB_TON_CONFIG_DATA),
	wCmdOut => CMD_CONFIG_DATA_RESULT);
IF CMD_CONFIG_DATA_RESULT <> 0 THEN
	CMD_CONFIG_DATA_LAST_FAIL := CMD_CONFIG_DATA_RESULT;
END_IF

IF FILE_WRITE_BUSY THEN

	(* Command or USB failure. *)
	IF EXEC_CONFIG_DATA.xError
		OR (
			ASYNC_EXECUTING
			AND NOT EXEC_CONFIG_DATA.xExecute
			AND CMD_CONFIG_DATA_RESULT <> 0
		)
		OR (
			ASYNC_EXECUTING
			AND USB_01.eDiagInfo =
				ifmTypes2.eDIAG_INFO.STAT_DONE
			AND USB_01.usiNumOfUSBdevice = 0
		) THEN

		FILE_WRITE_BUSY := FALSE;
		ASYNC_EXECUTING := FALSE;
		CONFIG_WRITE_TO_USB := FALSE;
		USB_READ_WRITE_VALID := FALSE;

		CMD_CONFIG_DATA_LAST_FAIL :=
			CMD_CONFIG_DATA_RESULT;
			
		IF  USB_01.eDiagInfo =
			ifmTypes2.eDIAG_INFO.STAT_DONE
			AND USB_01.usiNumOfUSBdevice = 0 THEN
			Data_Handling.CONFIG_STATUS_MSG := 'USB disconnected';
		ELSE
			Data_Handling.CONFIG_STATUS_MSG := 'USB write failed - try different USB';
		END_IF
		

	(* Completion condition. *)
	ELSIF ASYNC_EXECUTING AND NOT EXEC_CONFIG_DATA.xExecute THEN

		USB_CONFIG_FILE_SIZE :=
			SysFileGetSize(
				szFileName :=
					TEMPORARY_FILENAME_CONFIG_DATA,
				pResult :=
					ADR(USB_CONFIG_FILE_RESULT)
			);

		IF USB_CONFIG_FILE_RESULT = 0
			AND USB_CONFIG_FILE_SIZE > 150 THEN

			FILE_WRITE_BUSY := FALSE;
			ASYNC_EXECUTING := FALSE;
			USB_CONFIG_FILE_RESULT := 86;

			NVM.MACHINE_SERIAL_NUMBER_FROM_PLC :=
				MACHINE_SERIAL_VALUE;

			Data_Handling.CONFIG_STATUS_MSG :=
				'Settings copied to USB';

			USB_READ_WRITE_VALID := TRUE;

		ELSE

			FILE_WRITE_BUSY := FALSE;
			ASYNC_EXECUTING := FALSE;
			CONFIG_WRITE_TO_USB := FALSE;
			USB_READ_WRITE_VALID := FALSE;

			Data_Handling.CONFIG_STATUS_MSG :=
				'USB file was not created correctly';
		END_IF;
	END_IF;
END_IF;



