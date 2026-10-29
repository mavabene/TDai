
(********************** Declaration ****************************)
(* GPS offsets when entering RWP mode	 *)
METHOD writeTrackAssDataMessage_1 : BOOL
VAR_INPUT
// 	FH: RTS_IEC_HANDLE;
	
	(*
		0 = TA not used
		1 = TA used, then operator manually moved TD 
		2 = TA was final mover of tracks
		3 = TA auto advance used 
	*)
	
	// 
// 	HEADING_DELTA: UDINT; 
// 	X_DELTA: INT;
// 	Y_DELTA: UINT;
// 	Z_DELTA: INT;

END_VAR

(********************** Implementation ****************************)

// descriptive header
IF TA_ACC_COLLECTION_INIT THEN
	DATA := 'ENTER_RWP, ';
	DATA := CONCAT(DATA, 'TA Usage, ');
	DATA := CONCAT(DATA, 'Yaw (deg), ');
	DATA := CONCAT(DATA, 'X (mm), ');
	DATA := CONCAT(DATA, 'Y (mm), ');
	DATA := CONCAT(DATA, 'Z (mm), ');
	DATA := CONCAT(DATA, '$R$N');
	// write to temporary on board file
	write(FH := FH_TA_ACC_DATA);
END_IF

DATA := 'ENTER_RWP, ';
DATA := CONCAT(DATA, TO_STRING(TA_STATUS_FLAG));
DATA := CONCAT(DATA, ', ');

// GPS offsets entering RWP
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_HEADING].OFFSET));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_X].OFFSET));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_Y].OFFSET));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_Z].OFFSET));
DATA := CONCAT(DATA, '$R$N');
write(FH := FH_TA_ACC_DATA);
