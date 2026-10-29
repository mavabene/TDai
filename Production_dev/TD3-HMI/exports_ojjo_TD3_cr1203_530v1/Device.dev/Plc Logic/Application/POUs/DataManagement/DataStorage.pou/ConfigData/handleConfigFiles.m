
(********************** Declaration ****************************)
METHOD handleConfigFiles : BOOL

VAR_INPUT
END_VAR

(********************** Implementation ****************************)
handleConfigFiles := TRUE;

IF CONFIG_WRITE_TO_USB OR FILE_WRITE_BUSY THEN
	Data_Handling.CONFIG_STATUS_MSG := 'Writing Settings to USB';
	saveConfigDataToUSB();
	USB_PROCESSING := TRUE;
ELSIF CONFIG_LOAD_FROM_USB OR FILE_READ_BUSY THEN
	Data_Handling.CONFIG_STATUS_MSG := 'Loading Settings from USB';
	readConfigDataFromUSB();
	USB_PROCESSING := TRUE;
ELSIF PARSING_CONFIG_JSON THEN
	Data_Handling.CONFIG_STATUS_MSG := 'Reading JSON';
	parseConfigJSON();
	USB_PROCESSING := TRUE;
END_IF

IF CONFIG_FILE_TYPE <> CONFIG_FILE_TYPE_LAST THEN
	CONFIG_FILE_TYPE_LAST := CONFIG_FILE_TYPE;
	USB_READ_WRITE_VALID := FALSE;
END_IF

// handle processing indicator light
USB_PROCESSING :=
	ASYNC_EXECUTING
	OR CONFIG_WRITE_TO_USB
	OR CONFIG_LOAD_FROM_USB
	OR FILE_WRITE_BUSY
	OR FILE_READ_BUSY
	OR CONFIG_JSON_TRANSFER_STARTED
	OR CONFIG_JSON_PARSE_REQUEST
	OR CONFIG_JSON_PARSE_BUSY
	OR PARSING_CONFIG_JSON
	OR USB_01.eDiagInfo <> ifmTypes2.eDIAG_INFO.STAT_DONE;
IF USB_01.usiNumOfUSBdevice = 0 AND USB_01.eDiagInfo = ifmTypes2.eDIAG_INFO.STAT_DONE THEN
	Data_Handling.CONFIG_STATUS_MSG := 'No USB found';
ELSIF USB_01.eDiagInfo <> ifmTypes2.eDIAG_INFO.STAT_DONE THEN
	Data_Handling.CONFIG_STATUS_MSG := 'Searching for USB';	
ELSIF Data_Handling.CONFIG_STATUS_MSG = 'Searching for USB' AND USB_01.eDiagInfo = ifmTypes2.eDIAG_INFO.STAT_DONE AND USB_01.usiNumOfUSBdevice = 1 THEN
	Data_Handling.CONFIG_STATUS_MSG := 'USB found';
END_IF

IF USB_01.eDiagInfo <> ifmTypes2.eDIAG_INFO.STAT_DONE OR USB_PROCESSING THEN 
	USB_READ_WRITE_VALID := FALSE;
END_IF