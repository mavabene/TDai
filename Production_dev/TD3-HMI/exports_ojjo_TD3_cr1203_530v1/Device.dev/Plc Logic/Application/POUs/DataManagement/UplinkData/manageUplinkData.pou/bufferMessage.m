
(********************** Declaration ****************************)
METHOD bufferMessage : BOOL
VAR_INPUT
	NODE: USINT;
	INDEX: UINT;
	SUB_INDEX: USINT;
	DATA: ARRAY[1..8] OF USINT;
	LEN: UDINT;
END_VAR

(********************** Implementation ****************************)
IF NOT ENABLE_UPLINK_DATA THEN
	RETURN;
END_IF

BUFFER[HEAD].NODE := NODE;
BUFFER[HEAD].INDEX := INDEX;
BUFFER[HEAD].SUB_INDEX := SUB_INDEX;
BUFFER[HEAD].DATA := DATA;
BUFFER[HEAD].LEN := LEN;

BUFFER[HEAD].EXECUTE := TRUE;

HEAD := HEAD + 1;
IF HEAD > SIZE THEN
	HEAD := 1;
END_IF

IF HEAD = TAIL THEN
	HEAD := 1;
	TAIL := 1;
	OVERFLOWS := OVERFLOWS + 1;
END_IF

