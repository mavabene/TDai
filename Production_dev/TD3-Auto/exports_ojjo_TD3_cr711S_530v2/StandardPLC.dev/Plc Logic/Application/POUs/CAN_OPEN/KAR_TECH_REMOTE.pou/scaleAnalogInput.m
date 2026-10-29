
(********************** Declaration ****************************)
METHOD scaleAnalogInput : INT
VAR_INPUT
	READING: INT;
	ERROR: BOOL;
END_VAR
VAR
	TMP: REAL;
END_VAR

(********************** Implementation ****************************)

IF NOT ERROR THEN
	IF VendorID = eRemote.AUTEC THEN
		(*
		IF READING = 128 OR READING = 126 THEN
			READING := 127;
		END_IF *)
		IF READING > 127 THEN
			READING := READING - 1;
		END_IF
		TMP := READING - 127;
		TMP := TMP / 1.27;
		scaleAnalogInput := TO_INT(TMP);
	ELSE
		scaleAnalogInput := READING - 100;
	END_IF
ELSE
	scaleAnalogInput := 0;
END_IF