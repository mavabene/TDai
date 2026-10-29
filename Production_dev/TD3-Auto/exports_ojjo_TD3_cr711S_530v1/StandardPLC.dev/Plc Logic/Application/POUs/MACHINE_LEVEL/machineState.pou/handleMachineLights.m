
(********************** Declaration ****************************)
METHOD handleMachineLights
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IN_LIGHT_1_BUTTON(uiCHANNEL := LIGHT_1_BUTTON_POINT, eMode := ifmIOCommon.MODE_INPUT.IN_DIGITAL_CSI, xValueDigital => LIGHT_1_BUTTON, eDiagInfo => LIGHT_1_BUTTON_DIAG);
IF LIGHT_1_FORCE.FORCED THEN
	BTMP := LIGHT_1_FORCE.DOUT_STATE;
ELSIF LIGHT_1_BUTTON THEN
	// Switch is on requesting lighting.
	BTMP := TRUE;
END_IF
OUT_LIGHT_1(uiValue := TO_UINT(BTMP));

IN_LIGHT_2_BUTTON(uiCHANNEL := LIGHT_2_BUTTON_POINT, eMode := ifmIOCommon.MODE_INPUT.IN_DIGITAL_CSI, xValueDigital => LIGHT_2_BUTTON, eDiagInfo => LIGHT_2_BUTTON_DIAG);
IF LIGHT_2_FORCE.FORCED THEN
	BTMP := LIGHT_2_FORCE.DOUT_STATE;
ELSIF LIGHT_2_BUTTON THEN
	// Switch is on requesting lighting.
	BTMP := TRUE;
END_IF
OUT_LIGHT_2(uiValue := TO_UINT(BTMP));

