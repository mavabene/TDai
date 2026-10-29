
(********************** Declaration ****************************)
METHOD bufferScrewDriveDone : BOOL
VAR_INPUT
	SUCCESS: USINT;
	DATA8: USINT;
END_VAR
VAR
	STATUS: USINT;
	DATA: ARRAY[1..8] OF USINT;
	
	TM: UINT;
	LEN: UINT;
	EMBED: UINT;
END_VAR

(********************** Implementation ****************************)
IF NOT ENABLE_LHP_UPLINK THEN
	RETURN;
END_IF

// First three bytes is always screw number.
canUDint3ToBuffer(SCREW_NUMBER_TRANSMIT, ADR(DATA), 1);

DATA[4] := SHL((TO_USINT(EMBED_REDUCTION_DETECTED) AND 1), 7) OR (SUCCESS AND 1);

// Length in tenths of a cm, a.k.a. mm.
EMBED := TO_UINT(DRIVE_CURRENT_EMBEDMENT * 10.0);
DATA[5] := TO_USINT(SHR(EMBED, 8) AND 16#FF);
DATA[6] := TO_USINT(EMBED AND 16#FF);
TM := TO_UINT(DRIVE_TIME * 10.0);
DATA[7] := TO_USINT(SHR(TM, 8) AND 16#FF);
DATA[8] := TO_USINT(TM AND 16#FF);
bufferMessage(J1939_ADDRESS, SCREW_INDEX, SCREW_DONE_1_SUBINDEX, DATA, 8, TRUE);

LEN := TO_UINT(HAMMER_DISTANCE * 10.0);
DATA[5] := TO_USINT(SHR(LEN, 8) AND 16#FF);
DATA[6] := TO_USINT(LEN AND 16#FF);
IF DATA8 <> 255 THEN
	SCREW_DONE_CT := SCREW_DONE_CT + 1;
	IF SCREW_DONE_CT = 255 THEN
		SCREW_DONE_CT := 1;
	END_IF
	DATA8 := SCREW_DONE_CT;
END_IF
DATA[8] := DATA8;
bufferMessage(J1939_ADDRESS, SCREW_INDEX, SCREW_DONE_2_SUBINDEX, DATA, 8, TRUE);
