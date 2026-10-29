
(********************** Declaration ****************************)
METHOD fullRefresh : BOOL
VAR_INPUT
END_VAR
VAR
	IDX: USINT;
END_VAR
(********************** Implementation ****************************)
FOR IDX := 1 TO 7 DO
	forceUpdate(IDX);
END_FOR