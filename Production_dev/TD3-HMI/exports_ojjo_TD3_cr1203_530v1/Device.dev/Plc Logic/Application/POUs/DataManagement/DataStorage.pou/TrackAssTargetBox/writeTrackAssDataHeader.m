
(********************** Declaration ****************************)
METHOD writeTrackAssDataHeader : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)


DATA := 'GPS_TA_ACC, ';
DATA := CONCAT(DATA, TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE));
DATA := CONCAT(DATA, ', ');
IF RECEIVE_7_GPS.GPS_PNEZD_P = '' THEN
	DATA := CONCAT(DATA, 'noPnezd');
ELSE
	DATA := CONCAT(DATA, '"');
	DATA := CONCAT(DATA, RECEIVE_7_GPS.GPS_PNEZD_P);
	DATA := CONCAT(DATA, '"');
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
write(FH := FH_TA_ACC_DATA);
