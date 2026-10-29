
(********************** Declaration ****************************)
METHOD setupXmitData
VAR_INPUT
	LINE: USINT;
END_VAR

VAR
	INDEX: USINT;
	CHAR: USINT;
	AT_EOL: BOOL;
	PTR: POINTER TO BYTE;
END_VAR

(********************** Implementation ****************************)
PTR := ADR(LINES[LINE]);
AT_EOL := FALSE;

LINE_STATE[LINE] := 0;

// Fill in only the ASCII characters.  These are used for multiple transactions for a single change.  The
//	line and control/color registers are changed during the sequence of multiple transactions.
FOR INDEX := 1 TO 18 DO
	IF PTR^ = 0 THEN
		AT_EOL := TRUE;
	END_IF
	
	IF AT_EOL THEN
		// Fill in with spaces when message doesn't fill the entire field.
		CHAR := 32;
	ELSE
		// Otherwise take the next character from the message.
		CHAR := PTR^;
	END_IF
	
	PTR := PTR + 1;
 
	IF INDEX >= 1 AND INDEX <= 6 THEN
		// Characters 1 to 6 in first register.
		XMIT_COLUMN_1[INDEX + 2] := CHAR;
	ELSIF INDEX >= 7 AND INDEX <= 12 THEN
		// Characters 6 to 12 in second register.
		XMIT_COLUMN_2[INDEX + 2 - 6] := CHAR;
	ELSE
		// Characters 13 to 18 in third register.
		XMIT_COLUMN_3[INDEX + 2 - 12] := CHAR;
	END_IF
END_FOR