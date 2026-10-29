
(********************** Declaration ****************************)
METHOD validateJsonValue : BOOL

VAR_INPUT
	wsKey : WSTRING(255);

	eKind : eJsonConfigValueKind;

	xRequired : BOOL;
	xUseLimits : BOOL;

	lrMinimum : LREAL;
	lrMaximum : LREAL;
END_VAR

VAR_OUTPUT
	xFound : BOOL;
	jsonElement : JSON.JSONElement;
END_VAR

VAR
	JSON_ERROR_LOCAL : JSON.ERROR;
	xTypeOK : BOOL;
	xRangeOK : BOOL;
END_VAR
(********************** Implementation ****************************)
validateJsonValue := TRUE;
xFound := FALSE;

JSON_ERROR_LOCAL :=
	pJSON_DATA^.FindFirstValueByKey(
		wsKey := wsKey,
		diStartIndex := 0,
		jsonElement => jsonElement
	);

IF JSON_ERROR_LOCAL <> JSON.ERROR.NO_ERROR THEN

	IF xRequired THEN
		validateJsonValue := FALSE;
	END_IF;
	Data_Handling.CONFIG_STATUS_MSG := Standard.CONCAT(TO_STRING(wsKey), ' not found');
ELSE
	xFound := TRUE;
	xTypeOK := FALSE;
	xRangeOK := TRUE;

	CASE eKind OF

		eJsonConfigValueKind.eJSON_CFG_INTEGER:
			xTypeOK :=
				jsonElement.eType =
				JSON.JSONTYPE.LINT_VALUE;

			IF xTypeOK AND xUseLimits THEN
				xRangeOK :=
					(LINT_TO_LREAL(jsonElement.value.liValue)
						>= lrMinimum)
					AND
					(LINT_TO_LREAL(jsonElement.value.liValue)
						<= lrMaximum);
			END_IF;

		eJsonConfigValueKind.eJSON_CFG_REAL:
			xTypeOK :=
				jsonElement.eType =
				JSON.JSONTYPE.LREAL_VALUE;

			IF xTypeOK AND xUseLimits THEN
				xRangeOK :=
					(jsonElement.value.lrValue >= lrMinimum)
					AND
					(jsonElement.value.lrValue <= lrMaximum);
			END_IF;

		eJsonConfigValueKind.eJSON_CFG_BOOL:
			xTypeOK :=
				jsonElement.eType =
				JSON.JSONTYPE.BOOL_VALUE;

		eJsonConfigValueKind.eJSON_CFG_STRING:
			xTypeOK :=
				jsonElement.eType =
				JSON.JSONTYPE.WSTRING_VALUE;

	END_CASE;

	IF NOT xTypeOK OR NOT xRangeOK THEN
		validateJsonValue := FALSE;
		IF NOT xRangeOK THEN
			Data_Handling.CONFIG_STATUS_MSG := Standard.CONCAT(WSTRING_TO_STRING(wsKey), ' is out of range');
		ELSE
			Data_Handling.CONFIG_STATUS_MSG := Standard.CONCAT(WSTRING_TO_STRING(wsKey), ' is wrong data type');
		END_IF
	END_IF;
	
END_IF;