
(********************** Declaration ****************************)
METHOD singleWrite
VAR_INPUT
	LINE_CMD: BYTE;
	CONTROL_CMD: BYTE;
	MSG: ARRAY [1..8] OF USINT;
	ID: UDINT;
	DEAD_AFTER: DWORD;
END_VAR
VAR
	IDX: INT;
END_VAR
(********************** Implementation ****************************)
IF VendorID = eRemote.TELERADIO THEN
	MSG[1] := LINE_CMD;
ELSE
	MSG[1] := SHL(1, (LINE_CMD - 1));
END_IF

MSG[2] := CONTROL_CMD;
IF LINE_CMD = 0 AND CONTROL_CMD = 0 THEN
	FOR IDX := 3 TO 8 DO
		// Tele Radio hasn't figured out how to display text.  Put ASCII spaces into all character
		//	spots.
		MSG[IDX] := 32;
	END_FOR
END_IF
Can_TX3(xEnable := TRUE, xError => REMOTE_ERROR, eDiagInfo => TX_DIAG, eChannel := CHANNEL, udiID := ID,
	xExtended := TRUE, usiDLC := 8, aData := MSG);
LINE_STATE[LINE_CURRENT] := LINE_STATE[LINE_CURRENT] + 1;
DEAD := DEAD_AFTER;
