
(********************** Declaration ****************************)
METHOD parseRealSetting : BOOL
VAR_INPUT
	wsKey : WSTRING(255);
	secondPass : BOOL;
	xRequired : BOOL;
	lrMinimum : LREAL;
	lrMaximum : LREAL;
	pDestination : POINTER TO REAL;
END_VAR
VAR
	JSON_ELEMENT_LOCAL : JSON.JSONElement;
	xFound : BOOL;
END_VAR

(********************** Implementation ****************************)
parseRealSetting := TRUE;

IF NOT validateJsonValue(
	wsKey := wsKey,
	eKind := eJsonConfigValueKind.eJSON_CFG_REAL,
	xRequired := xRequired,
	xUseLimits := TRUE,
	lrMinimum := lrMinimum,
	lrMaximum := lrMaximum,
	jsonElement => JSON_ELEMENT_LOCAL,
	xFound => xFound
) THEN

	(* Missing required, wrong type, or out of range. *)
	parseRealSetting := FALSE;
	RETURN;
END_IF;

(* Missing optional value: valid no-op. *)
IF NOT xFound THEN
	RETURN;
END_IF;

IF secondPass THEN
	pDestination^ :=
		TO_REAL(JSON_ELEMENT_LOCAL.value.lrValue);
END_IF;
