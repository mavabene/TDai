
(********************** Declaration ****************************)
METHOD setColorAndString : BOOL
VAR_INPUT
	STATUS: _3SCOS.DEVICE_STATE;
	COLOR: POINTER TO DINT;
	STR: POINTER TO STRING;
END_VAR

(********************** Implementation ****************************)
(* Set string and color for reporting CanOpen sensor status. *)
IF (STATUS = 97) OR (STATUS = 99) THEN
	COLOR^ := 16#000000FF;
ELSE
	COLOR^ := 16#00008000;
END_IF;

CASE STATUS OF
	1:
		STR^ := 'Waiting For Bootup';
	2:
		STR^ := 'Bootup';
	3:
		STR^ := 'Prepared';
	4:
		STR^ := 'Pre-Operational';
	5:
		STR^ := 'Operational';
	97:
		STR^ := 'No Communication on Startup';
	99:
		STR^ := 'Communication Error';
	ELSE
		STR^ := 'Invalid';
END_CASE
