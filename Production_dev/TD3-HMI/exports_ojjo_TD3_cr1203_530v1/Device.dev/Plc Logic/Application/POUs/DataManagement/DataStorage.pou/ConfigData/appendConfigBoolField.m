
(********************** Declaration ****************************)
METHOD appendConfigBoolField : BOOL
VAR_INPUT
	sKey : STRING(255);
	xValue : BOOL;
END_VAR
VAR
	sValue : STRING(255);
END_VAR

(********************** Implementation ****************************)
IF xValue THEN
	sValue := 'true';
ELSE
	sValue := 'false';
END_IF;

appendConfigBoolField :=
	appendConfigField(
		sKey := sKey,
		sValue := sValue
	);