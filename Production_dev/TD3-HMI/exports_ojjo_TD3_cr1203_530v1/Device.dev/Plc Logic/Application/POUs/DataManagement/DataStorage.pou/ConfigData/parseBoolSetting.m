
(********************** Declaration ****************************)
METHOD parseBoolSetting  : BOOL
VAR_INPUT
	wsKey : WSTRING(255);
	secondPass : BOOL;
	xRequired : BOOL;
	pDestination : POINTER TO BOOL;
END_VAR
VAR
	JSON_ELEMENT_LOCAL : JSON.JSONElement;
	xFound : BOOL;
END_VAR

(********************** Implementation ****************************)
parseBoolSetting := TRUE;

IF NOT validateJsonValue(
		wsKey := wsKey,
		eKind := eJsonConfigValueKind.eJSON_CFG_BOOL,
		xRequired := xRequired,
		xUseLimits := FALSE,
		lrMinimum := 0.0,
		lrMaximum := 0.0,
		jsonElement => JSON_ELEMENT_LOCAL,
		xFound => xFound
	) THEN
	
	(* Missing required, wrong type, or out of range. *)
	parseBoolSetting := FALSE;
	RETURN;
END_IF;

(* Missing optional value: valid no-op. *)
IF NOT xFound THEN
	RETURN;
END_IF;

IF secondPass THEN
	pDestination^ :=
		JSON_ELEMENT_LOCAL.value.xValue;
END_IF;