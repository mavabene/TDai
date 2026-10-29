
(********************** Declaration ****************************)
METHOD bufferCycleTime : BOOL
VAR_INPUT
	STEP: INT;
	DAT: UINT;
	SCREW: UDINT;
	SIDE: INT;
	TRUSS: INT;
	MS: DWORD;
END_VAR
VAR
	DATA: ARRAY[1..8] OF USINT;
	ELAPSED_TENTHS: UINT;
END_VAR
(********************** Implementation ****************************)
IF NOT ENABLE_LHP_UPLINK THEN
	RETURN;
END_IF

(*
Cycle message:
- Latitude/longitude and date/time come from LHP gear
- Step (8 bit)
- Screw (3 bit)
- Side (2 bit)
- Truss type (2 bit)
- Elapsed time, tenth of second (16 bit => ~6500 seconds)
- Data (24 bit)
	=> Screw number when starting/ending screw
	=> Otherwise 0
*)

DATA[1] := TO_USINT(STEP);

DATA[2] := TO_USINT(SHL(TO_USINT(TRUSS) AND 16#03, 6)) + TO_USINT(SHL(TO_USINT(SIDE) AND 16#03, 4)) + (TO_USINT(TRUSS) AND 16#03);

ELAPSED_TENTHS := TO_UINT(TO_REAL(MS) / 100.0);
canUintToBuffer(ELAPSED_TENTHS, ADR(DATA), 3);

canUDint3ToBuffer(SCREW_NUMBER_TRANSMIT, ADR(DATA), 5);
DATA[8] := 0;

bufferMessage(J1939_ADDRESS, CYCLE_INDEX, CYCLE_SUBINDEX, DATA, 8, TRUE);