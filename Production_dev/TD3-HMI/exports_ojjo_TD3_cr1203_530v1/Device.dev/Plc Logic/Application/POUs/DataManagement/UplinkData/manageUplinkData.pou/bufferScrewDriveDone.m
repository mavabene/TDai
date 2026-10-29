
(********************** Declaration ****************************)
METHOD bufferScrewDriveDone : BOOL
VAR_INPUT
	SUCCESS: USINT;
END_VAR
VAR
	STATUS: USINT;
	DATA: ARRAY[1..8] OF USINT;
	
	TM: UINT;
	LEN: UINT;
	EMBED: UINT;
END_VAR

(********************** Implementation ****************************)
IF NOT ENABLE_UPLINK_DATA THEN
	RETURN;
END_IF

// First three bytes is alway screw number.
insertScrewNumber(SCREW_NUMBER_TRANSMIT, DATA, 1);

DATA[4] := SHL((TO_USINT(EMBED_REDUCTION_DETECTED) AND 1), 7) OR (SUCCESS AND 1);

// Length in tenths of a cm, a.k.a. mm.
EMBED := TO_UINT(DRIVE_CURRENT_EMBEDMENT * 10.0);
DATA[5] := TO_USINT(SHR(EMBED, 8) AND 16#FF);
DATA[6] := TO_USINT(EMBED AND 16#FF);
TM := TO_UINT(DRIVE_TIME * 10.0);
DATA[7] := TO_USINT(SHR(TM, 8) AND 16#FF);
DATA[8] := TO_USINT(TM AND 16#FF);
PLC_PRG.manageUplinkData_01.bufferMessage(LHP_NodeID, SCREW_INDEX, SCREW_DONE_1_SUBINDEX, DATA, 8);

LEN := TO_UINT(HAMMER_DISTANCE * 10.0);
DATA[5] := TO_USINT(SHR(LEN, 8) AND 16#FF);
DATA[6] := TO_USINT(LEN AND 16#FF);
PLC_PRG.manageUplinkData_01.bufferMessage(LHP_NodeID, SCREW_INDEX, SCREW_DONE_2_SUBINDEX, DATA, 8);
