
(********************** Declaration ****************************)
(* This message gets written to record distance away from target.  The resulting file should contain 	 *)
METHOD writeTrackAssDataMessage_2 : BOOL
VAR_INPUT

END_VAR

(********************** Implementation ****************************)

// descriptive header
IF TA_ACC_COLLECTION_INIT THEN
	TA_ACC_COLLECTION_INIT := FALSE; // done writing first messages
	DATA := 'ENTER_SCREW, ';
	DATA := CONCAT(DATA, 'Yaw (deg), ');
	DATA := CONCAT(DATA, 'X_slide (cm), ');
	DATA := CONCAT(DATA, 'Boom Swing (deg), ');
	DATA := CONCAT(DATA, 'Z_slide (cm), ');
	DATA := CONCAT(DATA, 'Yaw (deg), ');
	DATA := CONCAT(DATA, 'X (mm), ');
	DATA := CONCAT(DATA, 'Y (mm), ');
	DATA := CONCAT(DATA, 'Z (mm), ');
	DATA := CONCAT(DATA, '$R$N');
	// write to temporary on board file
	write(FH := FH_TA_ACC_DATA);
END_IF

DATA := 'ENTER_SCREW, ';

// actuator positions at completion of RWP
DATA := CONCAT(DATA, TO_STRING(TRUNION_ANGLE));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(X_SLIDE_POSITION));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(BOOM_SWING_ANGLE));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(Z_SLIDE_POSITION));
DATA := CONCAT(DATA, ', ');

// GPS offsets at completion of RWP
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_HEADING].OFFSET));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_X].OFFSET));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_Y].OFFSET));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(GPS_AXES[GPS_Z].OFFSET));
DATA := CONCAT(DATA, '$R$N');
write(FH := FH_TA_ACC_DATA);
