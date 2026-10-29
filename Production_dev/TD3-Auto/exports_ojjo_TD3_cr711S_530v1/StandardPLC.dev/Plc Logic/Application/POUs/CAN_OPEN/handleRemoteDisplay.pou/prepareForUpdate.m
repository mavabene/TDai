
(********************** Declaration ****************************)
METHOD prepareForUpdate
VAR_INPUT
	L: USINT;
	MSG: STRING;
END_VAR

(********************** Implementation ****************************)

LINES[L] := MSG;
forceUpdate(L);
