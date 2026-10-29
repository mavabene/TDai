
(********************** Declaration ****************************)
METHOD bufferScrewDriveStart : BOOL
VAR_INPUT
END_VAR
VAR
	DATA: ARRAY[1..8] OF USINT;
	ELAPSED_TENTHS: UINT;
	
	LEN: UINT;
	EMBED: UINT;
END_VAR

(********************** Implementation ****************************)
IF NOT ENABLE_UPLINK_DATA THEN
	RETURN;
END_IF

// First three bytes is alway screw number.
insertScrewNumber(SCREW_NUMBER_TRANSMIT, DATA, 1);

// Length in tenths of a cm, a.k.a. mm.
LEN := TO_UINT(DRIVE_SCREW_LENGTH * 10);
DATA[4] := TO_USINT(SHR(LEN, 8) AND 16#FF);
DATA[5] := TO_USINT(LEN AND 16#FF);
LEN := TO_UINT(DRIVE_LEG_LENGTH * 10);
DATA[6] := TO_USINT(SHR(LEN, 8) AND 16#FF);
DATA[7] := TO_USINT(LEN AND 16#FF);
PLC_PRG.manageUplinkData_01.bufferMessage(LHP_NodeID, SCREW_INDEX, SCREW_START_1_SUBINDEX, DATA, 8);

EMBED := TO_UINT(DRIVE_MINIMUM_EMBEDMENT * 10);
DATA[4] := TO_USINT(SHR(EMBED, 8) AND 16#FF);
DATA[5] := TO_USINT(EMBED AND 16#FF);
EMBED := TO_UINT(DRIVE_TARGET_EMBEDMENT * 10);
DATA[6] := TO_USINT(SHR(EMBED, 8) AND 16#FF);
DATA[7] := TO_USINT(EMBED AND 16#FF);
PLC_PRG.manageUplinkData_01.bufferMessage(LHP_NodeID, SCREW_INDEX, SCREW_START_2_SUBINDEX, DATA, 8);
