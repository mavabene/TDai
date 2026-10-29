
(********************** Declaration ****************************)
METHOD parseUIntSetting  : BOOL
VAR_INPUT
	wsKey : WSTRING(255);
	secondPass : BOOL;
	xRequired : BOOL;
	lrMinimum : LREAL;
	lrMaximum : LREAL;
	pDestination : POINTER TO UINT;
END_VAR
VAR
	JSON_ELEMENT_LOCAL : JSON.JSONElement;
	xFound : BOOL;
END_VAR

(********************** Implementation ****************************)
parseUIntSetting := TRUE;

IF NOT validateJsonValue(
		wsKey := wsKey,
		eKind := eJsonConfigValueKind.eJSON_CFG_INTEGER,
		xRequired := xRequired,
		xUseLimits := TRUE,
		lrMinimum := lrMinimum,
		lrMaximum := lrMaximum,
		jsonElement => JSON_ELEMENT_LOCAL,
		xFound => xFound
) THEN

	(* Missing required, wrong type, or out of range. *)
	parseUIntSetting := FALSE;
	RETURN;
END_IF;

(* Missing optional value: valid no-op. *)
IF NOT xFound THEN
	RETURN;
END_IF;

IF secondPass THEN
	pDestination^ :=
		TO_UINT(JSON_ELEMENT_LOCAL.value.liValue);
END_IF;