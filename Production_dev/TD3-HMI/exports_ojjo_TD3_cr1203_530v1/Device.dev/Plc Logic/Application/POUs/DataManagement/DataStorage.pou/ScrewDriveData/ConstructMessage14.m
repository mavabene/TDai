
(********************** Declaration ****************************)
(* This message is written periodically.  The sample frequency is turned down significantly from
	the screw drive data log frequency. *)
METHOD ConstructMessage14 : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
DATA := '14, ';
DATA := concat(DATA, TO_STRING(RECEIVE_1.TIME_SECONDS_FLOAT - TIME_ACQUISITION_START));
DATA := CONCAT(DATA, ', ');
LR_TMP := RECEIVE_1.LATITUDE;
DATA := CONCAT(DATA, TO_STRING(LR_TMP));
DATA := CONCAT(DATA, ', ');
LR_TMP := RECEIVE_1.LONGITUDE;
DATA := CONCAT(DATA, TO_STRING(LR_TMP));
DATA := CONCAT(DATA, '$R$N');

DataUplink.EnqueueMessage14(
    TIME_SINCE_MACHINE_POWER_ON := RECEIVE_1.TIME_SECONDS_FLOAT - TIME_ACQUISITION_START
);