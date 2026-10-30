
(********************** Declaration ****************************)
METHOD xmitLines
VAR_INPUT
END_VAR
VAR
	XMITTED: BOOL;
	IDX: USINT;
	CHRCTR: BYTE;
	AT_EOL: BOOL;

	DEBUG_DELAY: DWORD := 0; 
END_VAR

(********************** Implementation ****************************)
IF FIRST_TIME THEN
	IF VendorID = eRemote.TELERADIO THEN
		DEAD := 350;
	ELSIF VendorID = eRemote.AUTEC THEN
		DEAD := 100;
	END_IF
END_IF

IF LAST_XMIT >= (MSTIME - DEAD) THEN
	RETURN;
END_IF

XMITTED := FALSE;

IF FIRST_TIME THEN
	Can_Enable3(xENABLE := TRUE, eChannel := CHANNEL, eBaudrate := ifmDevice.CAN_BAUDRATE.KBAUD_250,
		xERROR => REMOTE_ERROR, eDiagInfo => INIT_DIAG);
END_IF

EXECUTE := EXECUTE + 1;
FOR LINE_CURRENT := 1 TO 7 DO
	IF XMITTED THEN
		// It appears that all of these radio receivers have significant limitations on data sent.
		RETURN;
	END_IF
		
	// We are either coming in with NEED_XMIT, which will have us in state 0, or XMITTING, which will walk
	//	us through all following states and back to 0.  Don't start a second line when the update for one
	//	line is already in process.
	IF (NOT LINE_IN_PROCESS AND NEED_XMIT[LINE_CURRENT]) OR XMITTING[LINE_CURRENT] THEN
		XMIT := XMIT + 1;
		LAST_XMIT := MSTIME;
	
		IF VendorID = eRemote.TELERADIO THEN
			CASE LINE_STATE[LINE_CURRENT] OF
				0:
					// This line of the display needs to be transmitted.  In case the line gets changed multiple
					//	times before being transmitted, don't latch until now.
					setupXmitData(LINE_CURRENT);
					NEED_XMIT[LINE_CURRENT] := FALSE;
					XMITTING[LINE_CURRENT] := TRUE;
					
					// Mark that we have starting updating one line.  Prevent other lines that are changed before the
					//	update is done from jumping in line.
					LINE_IN_PROCESS := TRUE;
	
					singleWrite(0, 0, XMIT_COLUMN_1, 16#18FF8007, DEBUG_DELAY);
				1:
					singleWrite(LINE_CURRENT, 16#40, XMIT_COLUMN_1, 16#18FF8007, DEBUG_DELAY);
				2:
					singleWrite(LINE_CURRENT, 16#80 + COLORS[LINE_CURRENT], XMIT_COLUMN_1, 16#18FF8007, 350);
				3:
					singleWrite(0, 0, XMIT_COLUMN_1, 16#18FF8007, DEBUG_DELAY);
				4:
					singleWrite(0, 0, XMIT_COLUMN_2, 16#18FF8107, DEBUG_DELAY);
				5:
					singleWrite(LINE_CURRENT, 16#40, XMIT_COLUMN_2, 16#18FF8107, DEBUG_DELAY);
				6:
					singleWrite(LINE_CURRENT, 16#80 + COLORS[LINE_CURRENT], XMIT_COLUMN_2, 16#18FF8107, 350);
				7:
					singleWrite(0, 0, XMIT_COLUMN_2, 16#18FF8107, DEBUG_DELAY);
				8:
					singleWrite(0, 0, XMIT_COLUMN_3, 16#18FF8207, DEBUG_DELAY);
				9:
					singleWrite(LINE_CURRENT, 16#40, XMIT_COLUMN_3, 16#18FF8207, DEBUG_DELAY);
				10:
					singleWrite(LINE_CURRENT, 16#80 + COLORS[LINE_CURRENT], XMIT_COLUMN_3, 16#18FF8207, 350);
				11:
					// Hack, added one more delay at end of complate line, for reasons unknown!
					singleWrite(0, 0, XMIT_COLUMN_3, 16#18FF8207, DEBUG_DELAY);
	
					// Done transmitting this line.
					LINE_STATE[LINE_CURRENT] := 0;
					XMITTING[LINE_CURRENT] := FALSE;
	
					LINE_IN_PROCESS := FALSE;
			END_CASE
		ELSIF VendorID = eRemote.AUTEC THEN
			CASE LINE_STATE[LINE_CURRENT] OF
				0:
					// This line of the display needs to be transmitted.  In case the line gets changed multiple
					//	times before being transmitted, don't latch until now.
					setupXmitData(LINE_CURRENT);
					NEED_XMIT[LINE_CURRENT] := FALSE;
					XMITTING[LINE_CURRENT] := TRUE;
					
					// Mark that we have starting updating one line.  Prevent other lines that are changed before the
					//	update is done from jumping in line.
					LINE_IN_PROCESS := TRUE;
					singleWrite(LINE_CURRENT, COLORS[LINE_CURRENT], XMIT_COLUMN_1, 16#18FF8007, 100);
				1:
					singleWrite(LINE_CURRENT, COLORS[LINE_CURRENT], XMIT_COLUMN_2, 16#18FF8107, 100);
				2:
					singleWrite(LINE_CURRENT, COLORS[LINE_CURRENT], XMIT_COLUMN_3, 16#18FF8207, 100);
					// Done transmitting this line.
					LINE_STATE[LINE_CURRENT] := 0;
					XMITTING[LINE_CURRENT] := FALSE;
	
					LINE_IN_PROCESS := FALSE;
			END_CASE
		END_IF
		XMITTED := TRUE;
	END_IF
END_FOR