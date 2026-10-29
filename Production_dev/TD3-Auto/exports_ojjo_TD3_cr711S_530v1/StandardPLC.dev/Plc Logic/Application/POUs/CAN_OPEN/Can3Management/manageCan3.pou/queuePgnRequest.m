
(********************** Declaration ****************************)
METHOD queuePgnRequest
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF TX_PGN_REQUEST THEN
	TX_PGN_REQUEST := FALSE;
	TX_ATTEMPTS := TX_ATTEMPTS + 1;
	
	// Priority 6, 0xEA00 is PGN request, 0x03 mimics the requests from the LHP.
	TX_MSG_ID := 16#18000000 + 16#00EA0000 + J1939_ADDRESS;
	
	DATA_WRITE[0] := TO_USINT(TX_PGN_NUMBER AND 16#FF);
	DATA_WRITE[1] := TO_USINT((SHR(TX_PGN_NUMBER, 8)) AND 16#FF);
	DATA_WRITE[2] := 0;
	TX_MSG_BYTES := 3;
	
	Can_TX3(xEnable := TRUE, xError => TX_ERROR, eDiagInfo => TX_DIAG, eChannel := CHANNEL, udiID := TX_MSG_ID,
		xExtended := TRUE, usiDLC := TX_MSG_BYTES, aData := DATA_WRITE);
		
	IF TX_ERROR THEN
		TX_FAIL := TX_FAIL + 1;
	END_IF
END_IF
