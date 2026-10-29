
(********************** Declaration ****************************)
METHOD readConfigDataFromUSB
VAR_INPUT
END_VAR
VAR

END_VAR

(********************** Implementation ****************************)


// USB_01 should be called once per scan, before this code.
Data_Handling.FILE_TRANSFER_USB_PRESENT := (USB_01.usiNumOfUSBdevice = 1);
	
IF NOT Data_Handling.FILE_TRANSFER_USB_PRESENT THEN
	Data_Handling.CONFIG_STATUS_MSG := 'USB not found';
END_IF

// Configure the transfer when the HMI request is active.
IF CONFIG_LOAD_FROM_USB AND
	NOT Data_Handling.FILE_READ_BUSY
	AND NOT CONFIG_JSON_TRANSFER_STARTED THEN
	
	CONFIG_JSON_TRANSFER_STARTED := TRUE;
	CONFIG_JSON_TRANSFER_WAS_BUSY := FALSE;
	// debug
	CONFIG_JSON_READ_TEXT_ATTEMPTED := FALSE;
	CONFIG_JSON_READ_TEXT_VALID := FALSE;
	CONFIG_JSON_READ_TEXT := '';
	CONFIG_JSON_PARSE_DONE := FALSE;
	CONFIG_JSON_PARSE_ERROR := FALSE;
	
	CASE Data_Handling.CONFIG_FILE_TYPE OF
	
		eConfigFileType.DrillSpecificSettings:
			CONFIG_DATA_FILENAME :=
				'DRILL_SETTINGS_CONFIG.json';
	
		eConfigFileType.JobSpecificSettings:
			CONFIG_DATA_FILENAME :=
				'JOB_SETTINGS_CONFIG.json';
	
		eConfigFileType.GeneralSettings:
			CONFIG_DATA_FILENAME :=
				'GENERAL_SETTINGS_CONFIG.json';
				
		eConfigFileType.MachineSpecificSettings:
			CONFIG_DATA_FILENAME :=
				'TD_SPECIFIC_SETTINGS_CONFIG.json';
	
	ELSE
		CONFIG_DATA_FILENAME := '';
	END_CASE
	
	Data_Handling.CONFIG_STATUS_MSG :=  Standard.CONCAT('Searching for ',CONFIG_DATA_FILENAME);
	
	IF CONFIG_DATA_FILENAME <> '' THEN
	
		FILE_TRANSFER_SOURCE_PATH :=
			CONCAT(
				USB_01.sAccessPath,
				'/ConfigData/'
			);
	
		FILE_TRANSFER_SOURCE_PATH :=
			CONCAT(
				FILE_TRANSFER_SOURCE_PATH,
				CONFIG_DATA_FILENAME
			);
	
		FILE_TRANSFER_DESTINATION_PATH :=
			'/home/Ojjo/data/config_read_test.json';
	
		FILE_TRANSFER_SOURCE_ON_USB := TRUE;
		FILE_TRANSFER_DESTINATION_ON_USB := FALSE;
	ELSE
		Data_Handling.CONFIG_STATUS_MSG := 'Invalid configuration file type';
	
		CONFIG_LOAD_FROM_USB := FALSE;
		CONFIG_JSON_TRANSFER_STARTED := FALSE;
		RETURN;
	END_IF;
// 	FILE_TRANSFER_SOURCE_PATH :=
// 		CONCAT(
// 			USB_01.sAccessPath,
// 			'/ConfigData/config_test.json'
// 		);
// 
// 	FILE_TRANSFER_DESTINATION_PATH :=
// 		'/home/Ojjo/data/config_read_test.json';
// 
// 	FILE_TRANSFER_SOURCE_ON_USB := TRUE;
// 	FILE_TRANSFER_DESTINATION_ON_USB := FALSE;
END_IF;


// Call the FB when starting or while it is busy.
IF CONFIG_LOAD_FROM_USB OR
	FILE_READ_BUSY THEN
	FILE_TRANSFER(
		xTransferRequest := CONFIG_LOAD_FROM_USB,
	
		sSourcePath := FILE_TRANSFER_SOURCE_PATH,
		sDestinationPath := FILE_TRANSFER_DESTINATION_PATH,
	
		tTimeout := T#30S,
	
		xSourceOnUSB := FILE_TRANSFER_SOURCE_ON_USB,
		xDestinationOnUSB := FILE_TRANSFER_DESTINATION_ON_USB,
	
		xUSBPresent := Data_Handling.FILE_TRANSFER_USB_PRESENT,
		sUSBAccessPath := USB_01.sAccessPath,
	
		xBusy => FILE_READ_BUSY,
		xDone => FILE_TRANSFER_DONE,
		xError => FILE_TRANSFER_ERROR,
		eState => FILE_TRANSFER_STATE,
		udiDestinationFileSize => FILE_TRANSFER_SIZE,
		eErrorCode => FILE_TRANSFER_ERROR_CODE,
		sErrorMessage => FILE_TRANSFER_ERROR_MESSAGE
	);
END_IF

IF FILE_TRANSFER_ERROR_CODE <> 0 THEN
	Data_Handling.CONFIG_STATUS_MSG := FILE_TRANSFER_ERROR_MESSAGE;
	CONFIG_LOAD_FROM_USB := FALSE;
	CONFIG_JSON_TRANSFER_STARTED := FALSE;
END_IF

// Read the completed USB transfer into the local JSON string.
IF FILE_TRANSFER_DONE 
	AND NOT CONFIG_JSON_READ_TEXT_ATTEMPTED 
	AND	CONFIG_JSON_TRANSFER_STARTED
	AND CONFIG_JSON_TRANSFER_WAS_BUSY THEN

	(* Prevent this block from running again. *)
	CONFIG_JSON_READ_TEXT_ATTEMPTED := TRUE;

	IF FILE_TRANSFER_SIZE >=
		TO_UDINT(SIZEOF(CONFIG_JSON_READ_TEXT)) THEN

		CONFIG_JSON_READ_TEXT_VALID := FALSE;
		CONFIG_JSON_PARSE_REQUEST := FALSE;
		PARSING_CONFIG_JSON := FALSE;
		CONFIG_JSON_PARSE_ERROR := TRUE;

		Data_Handling.CONFIG_STATUS_MSG :=
			'Configuration file is too large';

	ELSE

		FH_CONFIG_JSON_TEXT := SysFileOpen(
			szFile := FILE_TRANSFER_DESTINATION_PATH,
			am := ACCESS_MODE.AM_READ,
			pResult := ADR(
				ERROR_OPEN_CONFIG_JSON_TEXT
			)
		);

		IF FH_CONFIG_JSON_TEXT =
			RTS_INVALID_HANDLE THEN
	
			CONFIG_JSON_READ_TEXT := 'OPEN ERROR';
			CONFIG_JSON_READ_TEXT_VALID := FALSE;
		ELSE
			CONFIG_JSON_TEXT_BYTES_READ :=
				SysFileRead(
					hFile := FH_CONFIG_JSON_TEXT,
					pbyBuffer := ADR(
						CONFIG_JSON_READ_TEXT
					),
					ulSize := SIZEOF(CONFIG_JSON_READ_TEXT) - 1,
					pResult := ADR(
						ERROR_READ_CONFIG_JSON_TEXT
					)
				);
	
			IF ERROR_READ_CONFIG_JSON_TEXT = 0 
				AND CONFIG_JSON_TEXT_BYTES_READ > 0 THEN
	
				CONFIG_JSON_READ_TEXT[
					TO_INT(CONFIG_JSON_TEXT_BYTES_READ)
				] := 0;
	
				CONFIG_JSON_READ_TEXT_VALID := TRUE;
				CONFIG_JSON_PARSE_REQUEST := TRUE;
				PARSING_CONFIG_JSON := TRUE;
			ELSE
				CONFIG_JSON_READ_TEXT := 'READ ERROR';
				CONFIG_JSON_READ_TEXT_VALID := FALSE;
				Data_Handling.CONFIG_STATUS_MSG :=  Standard.CONCAT(CONFIG_DATA_FILENAME, ' not found');
			END_IF
	
			SysFileClose(
				hFile := FH_CONFIG_JSON_TEXT
			);
	
			FH_CONFIG_JSON_TEXT :=
				RTS_INVALID_HANDLE;
		END_IF
	END_IF
	(* This transfer has now been processed. *)
	CONFIG_JSON_TRANSFER_STARTED := FALSE;
	CONFIG_JSON_TRANSFER_WAS_BUSY := FALSE;
END_IF

IF FILE_READ_BUSY THEN
	CONFIG_JSON_TRANSFER_WAS_BUSY := TRUE;

	(* Clear the HMI command after the transfer has accepted it. *)
	CONFIG_LOAD_FROM_USB := FALSE;
END_IF