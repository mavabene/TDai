
(********************** Declaration ****************************)
METHOD writeFoundationAsBuiltHeader : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// descriptive header
IF GPS_AB_COLLECTION_INIT THEN
	GPS_AB_COLLECTION_INIT := FALSE;
	DATA := 'GPS_AS_BUILT_DATA, ';
	DATA := CONCAT(DATA, 'Stage, ');
	DATA := CONCAT(DATA, 'Man/Auto, ');
	DATA := CONCAT(DATA, 'Yaw (deg), ');
	DATA := CONCAT(DATA, 'X (mm), ');
	DATA := CONCAT(DATA, 'Y (mm), ');
	DATA := CONCAT(DATA, 'Z (mm), ');
	DATA := CONCAT(DATA, 'Pitch (deg), ');
	DATA := CONCAT(DATA, 'Roll (deg), ');
	DATA := CONCAT(DATA, 'RWP (s), ');
	DATA := CONCAT(DATA, 'HRMS (mm), ');
	DATA := CONCAT(DATA, 'VRMS (mm), ');
	DATA := CONCAT(DATA, 'PDOP (/), ');
	DATA := CONCAT(DATA, 'RTK (s)');
	DATA := CONCAT(DATA, '$R$N');
	// write to temporary on board file
	write(FH := FH_GPS_AB);
END_IF

DATA := 'MACHINE #:, ';
DATA := CONCAT(DATA, TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE));
DATA := CONCAT(DATA, ', ');
IF RECEIVE_7_GPS.GPS_PNEZD_P = '' THEN
	DATA := CONCAT(DATA, 'noPnezd');
	DATA := CONCAT(DATA, ', ');
	DATA := CONCAT(DATA, 'nopnezD');
ELSE
	DATA := CONCAT(DATA, '"');
	DATA := CONCAT(DATA, RECEIVE_7_GPS.GPS_PNEZD_P);
	DATA := CONCAT(DATA, '"');
	DATA := CONCAT(DATA, ', ');
	DATA := CONCAT(DATA, RECEIVE_7_GPS.GPS_PNEZD_D);
END_IF

DATA := CONCAT(DATA, ', ');
// Game the TO_STRING conversion into giving us one more digit of output with some
//	accuracy, and then a whole bunch of other garbage digits.
LR_TMP := RECEIVE_1.LATITUDE;
DATA := CONCAT(DATA, TO_STRING(LR_TMP));
DATA := CONCAT(DATA, ', ');
LR_TMP := RECEIVE_1.LONGITUDE;
DATA := CONCAT(DATA, TO_STRING(LR_TMP));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, '"');
DATA := CONCAT(DATA, DATETIME);
DATA := CONCAT(DATA, '"');
DATA := CONCAT(DATA, '$R$N');
// write to temporary on board file
write(FH := FH_GPS_AB);
