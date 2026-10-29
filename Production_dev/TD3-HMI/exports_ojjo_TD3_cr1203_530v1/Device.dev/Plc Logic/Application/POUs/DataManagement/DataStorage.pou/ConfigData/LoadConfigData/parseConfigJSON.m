
(********************** Declaration ****************************)
METHOD parseConfigJSON
VAR_INPUT
END_VAR
VAR

END_VAR


(********************** Implementation ****************************)
IF pJSON_DATA = 0 THEN
	pJSON_DATA := JSON_DATA_FACTORY.Create();
	IF pJSON_DATA = 0 THEN
		CONFIG_JSON_PARSE_BUSY := FALSE;
		CONFIG_JSON_PARSE_DONE := FALSE;
		CONFIG_JSON_PARSE_ERROR := TRUE;
		CONFIG_JSON_PARSE_REQUEST := FALSE;
		
		PARSING_CONFIG_JSON := FALSE;
		USB_READ_WRITE_VALID := FALSE;
		
		JSON_READER_EXECUTE := FALSE;
		JSON_READER_STARTED := FALSE;
	
		Data_Handling.CONFIG_STATUS_MSG :=
			'Could not create JSONData object';
	END_IF;
END_IF


IF CONFIG_JSON_PARSE_REQUEST
	AND NOT CONFIG_JSON_PARSE_BUSY
	AND NOT JSON_READER_STARTED
	AND NOT JSON_BYTE_ARRAY_READER.xDone
	AND NOT JSON_BYTE_ARRAY_READER.xError
	AND (pJSON_DATA <> 0) THEN

	CONFIG_JSON_PARSE_REQUEST := FALSE;
	CONFIG_JSON_PARSE_BUSY := TRUE;
	CONFIG_JSON_PARSE_DONE := FALSE;
	CONFIG_JSON_PARSE_ERROR := FALSE;
	(* Copy the STRING into a WSTRING without the 255-character
	   limit of the standard STRING conversion functions. *)
	(* Clear the WSTRING buffer. *)
// 	CONFIG_JSON_READ_WSTRING := WSTRING#'';
	SysMemSet(
		pDest := ADR(CONFIG_JSON_READ_WSTRING),
		udiValue := 0,
		udiCount := SIZEOF(CONFIG_JSON_READ_WSTRING)
	);
	
	JSON_TEXT_LENGTH :=
		TO_INT(
			Stu.StrLenA(
				ADR(CONFIG_JSON_READ_TEXT)
			)
		);

	IF JSON_TEXT_LENGTH > 0 THEN
		FOR JSON_CHAR_INDEX := 0 TO JSON_TEXT_LENGTH - 1 DO
			CONFIG_JSON_READ_WSTRING[JSON_CHAR_INDEX] :=
				TO_WORD(
					CONFIG_JSON_READ_TEXT[JSON_CHAR_INDEX]
				);
		END_FOR;
	END_IF;

	(* Clear the previous parsed JSON data. *)
	JSON_CLEAR_ERROR := pJSON_DATA^.Clear();

	IF JSON_CLEAR_ERROR <> JSON.ERROR.NO_ERROR THEN
		CONFIG_JSON_PARSE_BUSY := FALSE;
		CONFIG_JSON_PARSE_DONE := FALSE;
		CONFIG_JSON_PARSE_ERROR := TRUE;
		CONFIG_JSON_PARSE_REQUEST := FALSE;
		PARSING_CONFIG_JSON := FALSE;
		JSON_READER_EXECUTE := FALSE;
		JSON_READER_STARTED := FALSE;
	
		Data_Handling.CONFIG_STATUS_MSG :=
			'Could not clear JSON data';
	ELSE
		(* Rising edge starts JSONByteArrayReader. *)
		JSON_READER_EXECUTE := TRUE;
		JSON_READER_STARTED := TRUE;
	END_IF;
END_IF;

IF pJSON_DATA <> 0 THEN
	JSON_BYTE_ARRAY_READER(
		xExecute := JSON_READER_EXECUTE,
		pwData := ADR(CONFIG_JSON_READ_WSTRING),
		xIgnoreValueStringLength := FALSE,
		xAsyncMode := TRUE,
		jsonData := pJSON_DATA^
	);
	Data_Handling.CONFIG_STATUS_MSG :=  Standard.CONCAT('reading ', CONFIG_DATA_FILENAME);
END_IF;

IF JSON_READER_STARTED
	AND JSON_BYTE_ARRAY_READER.xBusy THEN

	JSON_READER_EXECUTE := FALSE;
ELSIF JSON_READER_STARTED
	AND JSON_BYTE_ARRAY_READER.xDone THEN
	JSON_READER_EXECUTE := FALSE;
	JSON_READER_STARTED := FALSE;
	CONFIG_JSON_PARSE_BUSY := FALSE;

	CONFIG_JSON_PARSE_DONE := FALSE;
	CONFIG_JSON_PARSE_ERROR := FALSE;
	USB_READ_WRITE_VALID := FALSE;

	(* The reader is finished; JSONData can now be searched. *)
	TMP_PARSE_OK := TRUE;
	Data_Handling.CONFIG_STATUS_MSG :=  'searching for settings data';

	(* ----------------------------- *)
	(* Pass 1: find and validate only *)
	(* Pass 2: if all values found, write values *)
	(* ----------------------------- *)
	CASE Data_Handling.CONFIG_FILE_TYPE OF

		eConfigFileType.DrillSpecificSettings:
			TMP_PARSE_OK := parseDrillSettings(secondPass := FALSE);
			IF TMP_PARSE_OK THEN
				TMP_PARSE_OK := parseDrillSettings(secondPass := TRUE);
			END_IF
			
		eConfigFileType.JobSpecificSettings:
			TMP_PARSE_OK := parseJobSettings(secondPass := FALSE);
			IF TMP_PARSE_OK THEN
				TMP_PARSE_OK := parseJobSettings(secondPass := TRUE);
			END_IF
			
		eConfigFileType.MachineSpecificSettings:
			TMP_PARSE_OK := parseMachineSpecificSettings(secondPass := FALSE);
			IF TMP_PARSE_OK THEN
				TMP_PARSE_OK := parseMachineSpecificSettings(secondPass := TRUE);
			END_IF
		eConfigFileType.GeneralSettings:
			TMP_PARSE_OK := parseGeneralSettings(secondPass := FALSE);
			IF TMP_PARSE_OK THEN
				TMP_PARSE_OK := parseGeneralSettings(secondPass := TRUE);
			END_IF
			
	ELSE
		TMP_PARSE_OK := FALSE;
	END_CASE;
	(* Final result *)
	IF TMP_PARSE_OK THEN
		CONFIG_JSON_PARSE_DONE := TRUE;
		CONFIG_JSON_PARSE_ERROR := FALSE;
		USB_READ_WRITE_VALID := TRUE;
		Data_Handling.CONFIG_STATUS_MSG := 'Settings Written';
	ELSE
		CONFIG_JSON_PARSE_DONE := FALSE;
		CONFIG_JSON_PARSE_ERROR := TRUE;
		USB_READ_WRITE_VALID := FALSE;
	END_IF;

	PARSING_CONFIG_JSON := FALSE;
	CONFIG_JSON_PARSE_BUSY := FALSE;

ELSIF JSON_READER_STARTED
	AND JSON_BYTE_ARRAY_READER.xError THEN

	JSON_READER_STARTED := FALSE;
	JSON_READER_EXECUTE := FALSE;
	CONFIG_JSON_PARSE_BUSY := FALSE;
	CONFIG_JSON_PARSE_DONE := FALSE;
	CONFIG_JSON_PARSE_ERROR := TRUE;
	USB_READ_WRITE_VALID := FALSE;
	PARSING_CONFIG_JSON := FALSE;
END_IF;