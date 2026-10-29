
(********************** Declaration ****************************)
(* This message gets written every time the cycle step changes.  The resulting file should contain 	 *)
METHOD writeCycleMessage103 : BOOL
VAR_INPUT
	FH: RTS_IEC_HANDLE;	
	STEP: INT;
	DAT: UINT;
	SCREW: UDINT;
	SIDE: INT;
	TRUSS: INT;
END_VAR

(********************** Implementation ****************************)

DATA := '103, ';
DATA := CONCAT(DATA, TO_STRING(STEP));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(DAT));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(SCREW));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(SIDE));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(TRUSS));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(TIME_SECONDS_FLOAT));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(ELAPSED_TIME_SECONDS));
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

DataUplink.EnqueueMessage103(
    STATE_NUMBER := STEP,
    CYCLE_DATA := DAT,
    CYCLE_SCREW_ID := SCREW,
    CYCLE_SCREW_SIDE := SIDE,
    CYCLE_TRUSS_TYPE := TRUSS,
    TIME_ELAPSED := TIME_SECONDS_FLOAT,
    CYCLE_TIME_ELAPSED := ELAPSED_TIME_SECONDS
);
