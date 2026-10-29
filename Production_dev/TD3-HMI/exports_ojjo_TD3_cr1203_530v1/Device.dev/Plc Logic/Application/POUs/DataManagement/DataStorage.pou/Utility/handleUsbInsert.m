
(********************** Declaration ****************************)
METHOD handleUsbInsert
VAR_INPUT
END_VAR
VAR
	USB_PATH : STRING[255];
END_VAR
(********************** Implementation ****************************)

(* USB folders are made here.  If we try to write a file where a folder does not exist, it fails silently *)

(* *********************** HANDLE INSERTED USB DRIVE ********************************)
IF (LAST_usiNumOfUSBdevice = 0 AND USB_01.usiNumOfUSBdevice = 1 AND NOT EXEC_03.xExecute) OR NEEDS_INIT THEN
	
	USB_PATH := CONCAT(USB_01.sAccessPath, '/');

	// USB has been inserted.  Make sure we have proper directories setup.
	
	// clear the command so we don't reuse anything leftover
	// length of COMMAND_USB currently limited to 255
	COMMAND_USB := '';
	
	USB_PATH := CONCAT(USB_01.sAccessPath, '/');
	
	COMMAND_USB := CONCAT(COMMAND_USB, 'mkdir -p ');
	
	COMMAND_USB := CONCAT(COMMAND_USB, USB_PATH);
	COMMAND_USB := CONCAT(COMMAND_USB, DIRECTORY_CYCLE_TIME);
	COMMAND_USB := CONCAT(COMMAND_USB, ' ');
	
	COMMAND_USB := CONCAT(COMMAND_USB, USB_PATH);
	COMMAND_USB := CONCAT(COMMAND_USB, DIRECTORY_SCREW_DRIVE);
	COMMAND_USB := CONCAT(COMMAND_USB, ' ');
	
	COMMAND_USB := CONCAT(COMMAND_USB, USB_PATH);
	COMMAND_USB := CONCAT(COMMAND_USB, DIRECTORY_STOPWATCH);
	COMMAND_USB := CONCAT(COMMAND_USB, ' ');
	
	COMMAND_USB := CONCAT(COMMAND_USB, USB_PATH);
	COMMAND_USB := CONCAT(COMMAND_USB, DIRECTORY_GPS_AB_DATA);
	COMMAND_USB := CONCAT(COMMAND_USB, ' ');
	
	COMMAND_USB := CONCAT(COMMAND_USB, USB_PATH);
	COMMAND_USB := CONCAT(COMMAND_USB, DIRECTORY_TA_DATA);
	COMMAND_USB := CONCAT(COMMAND_USB, ' ');
	
	COMMAND_USB := CONCAT(COMMAND_USB, USB_PATH);
	COMMAND_USB := CONCAT(COMMAND_USB, DIRECTORY_CONFIG_DATA);
	
	prepLinuxAsync(
		pASYNC := ADR(EXEC_03),
		pTON := ADR(USB_TON_03),
		CMD := COMMAND_USB,
		TIMEOUT := T#30S
	);
END_IF

// If we have just inserted a UBS and need to create the proper directories, xExecute will be TRUE.  Run this system
//	COMMAND_USB and immediately return if this has not completed yet.
IF EXEC_03.xExecute THEN
	ASYNC_03(pASYNC := ADR(EXEC_03), pTON := ADR(USB_TON_03), wCmdOut => CMD3_RESULT);
	IF CMD3_RESULT <> 0 THEN
		CMD3_LAST_FAIL := CMD3_RESULT;
	END_IF
	RETURN;
END_IF
