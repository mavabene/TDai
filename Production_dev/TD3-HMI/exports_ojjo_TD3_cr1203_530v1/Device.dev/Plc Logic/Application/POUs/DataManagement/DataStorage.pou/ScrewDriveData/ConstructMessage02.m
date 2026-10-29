
(********************** Declaration ****************************)
(* This message gets written once at the beginning of each screw drive.  It contains top level system information
	like machine position and the software system setup. *)
METHOD ConstructMessage02 : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
DATA := '2, ';
DATA := CONCAT(DATA, TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE));
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
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(10 / DATA_ACQ_FREQ_DIVISOR));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, PLC_VERSION);
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, VersionHMI.VERSION);
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, RECEIVE_7_GPS.GPS_PNEZD_P);
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_7_GPS.GPS_PNEZD_N));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_7_GPS.GPS_PNEZD_E));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_7_GPS.GPS_PNEZD_Z));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, RECEIVE_7_GPS.GPS_PNEZD_D);
DATA := CONCAT(DATA, '$R$N');

DataUplink.EnqueueMessage2();