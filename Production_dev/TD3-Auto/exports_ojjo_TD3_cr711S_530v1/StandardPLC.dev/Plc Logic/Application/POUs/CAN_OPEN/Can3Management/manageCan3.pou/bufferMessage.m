
(********************** Declaration ****************************)
METHOD bufferMessage : BOOL
VAR_INPUT
	NODE: USINT;
	INDEX: UINT;
	SUB_INDEX: USINT;
	DATA: ARRAY[1..8] OF USINT;
	LEN: USINT;
	EXTENDED: BOOL; // False for 11 bit standard message
END_VAR

(********************** Implementation ****************************)
// Do not buffer any messages before the address claim goes out.
IF NOT ENABLE_LHP_UPLINK OR FIRST_TIME THEN
	RETURN;
END_IF

BUFFER[HEAD].NODE := NODE;
BUFFER[HEAD].INDEX := INDEX;
BUFFER[HEAD].SUB_INDEX := SUB_INDEX;
BUFFER[HEAD].DATA := DATA;
BUFFER[HEAD].LEN := LEN;
BUFFER[HEAD].EXTENDED := EXTENDED;

// Not in the middle of executing a write...
BUFFER[HEAD].EXECUTE := FALSE;

HEAD := HEAD + 1;
IF HEAD > SIZE THEN
	HEAD := 1;
END_IF

IF HEAD = TAIL THEN
	HEAD := 1;
	TAIL := 1;
	OVERFLOWS := OVERFLOWS + 1;
END_IF

