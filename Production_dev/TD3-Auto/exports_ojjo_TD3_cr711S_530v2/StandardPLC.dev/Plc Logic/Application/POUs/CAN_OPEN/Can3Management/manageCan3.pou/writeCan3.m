
(********************** Declaration ****************************)
METHOD writeCan3
VAR_INPUT
END_VAR

VAR
	DONE: BOOL;
	ERROR: BOOL;
	
END_VAR
(********************** Implementation ****************************)
queuePgnRequest();

// To here all messages have been queued.  Now pull messages out as we can to transmit.
	
SYS_TIME := SysTimeGetMs();

// Tail message will go through three states:
//	- Idle (head == tail)
//	- Ready for transmit (head <> tail), execute = false
//	- Transmitting (head <> tail), execute = true
//
//	When buffering a new message, the EXECUTE member must be set false!
//
ERROR := FALSE;

IF HEAD <> TAIL AND NOT ERROR THEN
	TX_LOOPS := TX_LOOPS + 1;
	IF BUFFER[TAIL].EXECUTE = FALSE THEN
		// We want to send this out on the CanBus!
		BUFFER[TAIL].EXECUTE := TRUE;
		
		// Pull data from queue and format message for transmit.
		IF BUFFER[TAIL].EXTENDED THEN
			TX_MSG_ID := 16#18000000 + SHL(TO_UDINT(BUFFER[TAIL].INDEX), 16) + SHL(TO_UDINT(BUFFER[TAIL].SUB_INDEX), 8) + BUFFER[TAIL].NODE; // J1939 (29 bit)
		ELSE
			TX_MSG_ID := SHL(TO_UDINT(BUFFER[TAIL].SUB_INDEX), 8) + BUFFER[TAIL].NODE; // standard (11 bit) CAN
		END_IF
		
		Can_TX3(xEnable := TRUE, xError => ERROR, eDiagInfo => TX_DIAG, eChannel := CHANNEL, udiID := TX_MSG_ID,
			xExtended := BUFFER[TAIL].EXTENDED, usiDLC := BUFFER[TAIL].LEN, aData := BUFFER[TAIL].DATA);
		TX_ATTEMPTS := TX_ATTEMPTS + 1;
		
	ELSE
		// Added this logic in case we switch to an API that needs to be called multiple times per one message.  The Can_TX that
		//	we are using simply attempts to buffer, so typically should return only DONE or BUFFER_FULL.
		;
	END_IF
	
	IF TX_DIAG = ifmTypes.DIAG_INFO.STAT_DONE OR ERROR THEN
		IF ERROR AND TX_DIAG = ifmTypes.DIAG_INFO.ERR_BUFFER_OVERFLOW THEN
			// Internal buffer overflow... exit and live to fight another day.
			TX_FULL := TX_FULL + 1;
		ELSIF ERROR THEN
			TX_FAIL := TX_FAIL + 1;
		ELSIF TX_DIAG = ifmTypes.DIAG_INFO.STAT_DONE AND NOT ERROR THEN
			TX_SUCCESS := TX_SUCCESS + 1;
		END_IF
		
		IF NOT BUFFER[TAIL].EXTENDED (*AND (  // gps messages - get correct id # eg NODE_ID := to_USINT(16#FF and 16#1A0);
				TX_MSG_ID = 16#1A0 OR
				TX_MSG_ID = 16#2A0 OR
				TX_MSG_ID = 16#194 OR
				TX_MSG_ID = 16#21E OR
				TX_MSG_ID = 16#31E OR
				TX_MSG_ID = 16#41E )*) THEN
		
			GPS_CAN_TX_ERROR := ERROR;
			IF NOT ERROR THEN
				GPS_CAN_TX_MSGS := GPS_CAN_TX_MSGS + 1 ;
			END_IF
		END_IF
		
		// Clear status flags.
		BUFFER[TAIL].EXECUTE := FALSE;
		
		// Unbuffer message.
		TAIL := TAIL + 1;
		IF TAIL > SIZE THEN
			TAIL := 1;
		END_IF
	ELSE
		TX_NOERRDONE := TX_NOERRDONE + 1;
	END_IF
END_IF