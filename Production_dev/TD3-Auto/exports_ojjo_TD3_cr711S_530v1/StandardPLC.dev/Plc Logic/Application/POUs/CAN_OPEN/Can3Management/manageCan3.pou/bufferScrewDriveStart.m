
(********************** Declaration ****************************)
METHOD bufferScrewDriveStart : BOOL
VAR_INPUT
	DATA8: USINT;
END_VAR
VAR
	DATA: ARRAY[1..8] OF USINT;
	ELAPSED_TENTHS: UINT;
	
	LEN: UINT;
	EMBED: UINT;
END_VAR

(********************** Implementation ****************************)
IF NOT ENABLE_LHP_UPLINK THEN
	RETURN;
END_IF

// First three bytes is alway screw number.
canUDint3ToBuffer(SCREW_NUMBER_TRANSMIT, ADR(DATA), 1);

// Length in tenths of a cm, a.k.a. mm.
LEN := TO_UINT(DRIVE_SCREW_LENGTH * 10);
canUintToBuffer(LEN, ADR(DATA), 4);
LEN := TO_UINT(DRIVE_LEG_LENGTH * 10);
canUintToBuffer(LEN, ADR(DATA), 4);
bufferMessage(J1939_ADDRESS, SCREW_INDEX, SCREW_START_1_SUBINDEX, DATA, 8, TRUE);

EMBED := TO_UINT(DRIVE_MINIMUM_EMBEDMENT * 10);
canUintToBuffer(EMBED, ADR(DATA), 4);
EMBED := TO_UINT(DRIVE_TARGET_EMBEDMENT * 10);
canUintToBuffer(EMBED, ADR(DATA), 4);

IF DATA8 <> 255 THEN
	SCREW_START_CT := SCREW_START_CT + 1;
	IF SCREW_START_CT = 255 THEN
		SCREW_START_CT := 1;
	END_IF
	DATA8 := SCREW_START_CT;
END_IF
DATA[8] := DATA8;
bufferMessage(J1939_ADDRESS, SCREW_INDEX, SCREW_START_2_SUBINDEX, DATA, 8, TRUE);
