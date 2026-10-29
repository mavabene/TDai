
(********************** Declaration ****************************)
METHOD insertScrewNumber : BOOL
VAR_INPUT
	NUMBER: UDINT;
	DATA: ARRAY[1..8] OF USINT;
	START: USINT;
END_VAR

(********************** Implementation ****************************)
IF NOT ENABLE_UPLINK_DATA THEN
	RETURN;
END_IF

// Always insert 24 bits of screw number, LSBs are toward the front of the CanBus packet, so little endian.
DATA[START] := TO_USINT(SHR(NUMBER, 16) AND 16#FF);
DATA[START + 1] := TO_USINT(SHR(NUMBER, 8) AND 16#FF);
DATA[START + 2] := TO_USINT(NUMBER AND 16#FF);
