
(********************** Declaration ****************************)
(* This message gets written once at the end of an *UNsuccessful* screw drive. *)
METHOD ConstructMessage13 : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
DATA := '13, 2, ';

// Version 1 of this message.
//DATA := CONCAT(DATA, TO_STRING(RECEIVE_1.LATITUDE));
//DATA := CONCAT(DATA, ', ');
//DATA := CONCAT(DATA, TO_STRING(RECEIVE_1.LONGITUDE));
//DATA := CONCAT(DATA, '$R$N');

// Version 2 of this message: makes it match the success message, so that we can find screwns that
//	end in Manual but did hit embedment.
DATA := CONCAT(DATA, TO_STRING(RECEIVE_1.LATITUDE));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_1.LONGITUDE));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_3.DRIVE_CURRENT_EMBEDMENT));
DATA := CONCAT(DATA, ', ');
DATA := concat(DATA, TO_STRING(RECEIVE_3.DRIVE_TIME));
DATA := CONCAT(DATA, ', ');
//DATA := CONCAT(DATA, TO_STRING(RECEIVE_1.LATITUDE));
//DATA := CONCAT(DATA, ', ');
//DATA := CONCAT(DATA, TO_STRING(RECEIVE_1.LONGITUDE));
//DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_3.EMBED_REDUCTION_DETECTED));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_3.EMBEDMENT_REDUCTION));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_3.EMBEDMENT_REDUCTION_STRUCTURAL));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_3.HAMMER_DISTANCE));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_3.WATER_VOLUME_L));
DATA := CONCAT(DATA, ', ');
DATA := CONCAT(DATA, TO_STRING(RECEIVE_1.DRIVE_LEG_LENGTH));
DATA := CONCAT(DATA, '$R$N');

DataUplink.EnqueueMessage13();