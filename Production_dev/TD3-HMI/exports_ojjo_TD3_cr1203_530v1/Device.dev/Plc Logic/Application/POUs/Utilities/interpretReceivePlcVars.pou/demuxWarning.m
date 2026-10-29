
(********************** Declaration ****************************)
METHOD demuxWarning : BOOL
VAR_INPUT
	pWBIT: POINTER TO BOOL;
	MASK: DWORD;
	MSG: STRING;
END_VAR

(********************** Implementation ****************************)
pWBIT^ := (RECEIVE_1.WARNING_CURRENT AND MASK) <> 0;
IF pWBIT^ THEN
	IF WARNINGS <> 0 THEN
		NOTIFICATIONS := CONCAT(STR1 := NOTIFICATIONS, STR2 := ', ');
	END_IF;
	NOTIFICATIONS := CONCAT(STR1 := NOTIFICATIONS, STR2 := MSG);
	WARNINGS := WARNINGS + 1;
END_IF
