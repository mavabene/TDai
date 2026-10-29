
(********************** Declaration ****************************)
METHOD bufferCycleTime : BOOL
VAR_INPUT
	STEP: INT;
	DAT: UINT;
	SCREW: UDINT;
	SIDE: INT;
	TRUSS: INT;
END_VAR
VAR
	DATA: ARRAY[1..8] OF USINT;
	ELAPSED_TENTHS: UINT;
END_VAR
(********************** Implementation ****************************)
IF NOT ENABLE_UPLINK_DATA THEN
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
DATA[2] := TO_USINT(SHL(TO_USINT(SCREW) AND 16#07, 5)) + TO_USINT(SHL(TO_USINT(SIDE) AND 16#03, 2)) + (TO_USINT(TRUSS) AND 16#03);
ELAPSED_TENTHS := TO_UINT(DataStorage.ELAPSED_TIME_SECONDS * 10.0);
DATA[3] := TO_USINT(SHR(ELAPSED_TENTHS, 8));
DATA[4] := TO_USINT(ELAPSED_TENTHS AND 16#FF);
insertScrewNumber(SCREW_NUMBER_TRANSMIT, DATA, 5);
DATA[8] := 0;

PLC_PRG.manageUplinkData_01.bufferMessage(LHP_NodeID, CYCLE_INDEX, CYCLE_SUBINDEX, DATA, 8);