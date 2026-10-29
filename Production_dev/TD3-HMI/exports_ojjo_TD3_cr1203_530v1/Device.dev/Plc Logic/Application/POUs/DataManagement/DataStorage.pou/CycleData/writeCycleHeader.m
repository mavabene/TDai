
(********************** Declaration ****************************)
METHOD writeCycleHeader : BOOL
VAR_INPUT
	FH: RTS_IEC_HANDLE;	
END_VAR

(********************** Implementation ****************************)
DATA := '1, 1, "Ojjo", "CycleTime"$R$N';
write(FH := FH_CYCLE);

DATA := '102, ';
DATA := CONCAT(DATA, TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(TIME_SECONDS_FLOAT));
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
write(FH := FH_CYCLE);


DataUplink.EnqueueMessage102(TIME_ELAPSED := TIME_SECONDS_FLOAT);