
(********************** Declaration ****************************)
METHOD handleProximitySensor
VAR_INPUT
END_VAR
VAR
	
END_VAR
(********************** Implementation ****************************)


(* Collect inputs *)
// IN_PROXIMITY_SENSOR_NO(uiCHANNEL := PROXIMITY_SENSOR_NO_POINT, eMode := ifmIOCommon.MODE_INPUT.IN_DIGITAL_CSI, xValueDigital => PROXIMITY_SENSOR_ALARM_ON, eDiagInfo => PROXIMITY_SENSOR_ON_ALARM_OFF_DIAG);
// IN_PROXIMITY_SENSOR_NC(uiCHANNEL := PROXIMITY_SENSOR_NC_POINT, eMode := ifmIOCommon.MODE_INPUT.IN_DIGITAL_CSI, xValueDigital => PROXIMITY_SENSOR_ON_ALARM_OFF, eDiagInfo => PROXIMITY_SENSOR_ON_ALARM_OFF_DIAG);

IN_PROXIMITY_SENSOR_NO(uiCHANNEL := PROXIMITY_SENSOR_NO_POINT, eMode := ifmIOCommon.MODE_INPUT.IN_DIGITAL_CSI, xValueDigital => PROXIMITY_SENSOR_ON_ALARM_OFF, eDiagInfo => PROXIMITY_SENSOR_ON_ALARM_OFF_DIAG);
IN_PROXIMITY_SENSOR_NC(uiCHANNEL := PROXIMITY_SENSOR_NC_POINT, eMode := ifmIOCommon.MODE_INPUT.IN_DIGITAL_CSI, xValueDigital => PROXIMITY_SENSOR_ALARM_ON, eDiagInfo => PROXIMITY_SENSOR_ALARM_ON_DIAG);

PROXIMITY_SENSOR_WARNING := ( LAST_PROXIMITY_SENSOR_CYCLE_WARNING AND (PROXIMITY_SENSOR_ALARM_ON = PROXIMITY_SENSOR_ON_ALARM_OFF) AND pNVM4^.HMI_BOOLS[PROXIMITY_SENSOR_INSTALLED]);
TestVar5 := PROXIMITY_SENSOR_ALARM_ON; // proximity alarm output on (alarm off)

// // Test
// // simulate sensor not working properly
// IF DEBUG_TEST_INT =  1 THEN
// 	PROXIMITY_SENSOR_WARNING := TRUE;
// // simulate sensor working and alarming
// ELSIF DEBUG_TEST_INT = 2 THEN
// 	PROXIMITY_SENSOR_ALARM_ON := TRUE;
// 	PROXIMITY_SENSOR_ON_ALARM_OFF := FALSE;
// // simulate sensor working and not alarming
// ELSIF DEBUG_TEST_INT = 3 THEN
// 	PROXIMITY_SENSOR_ALARM_ON := FALSE;
// 	PROXIMITY_SENSOR_ON_ALARM_OFF := TRUE;
// END_IF

(* Proximity Alarm Mute Control *)
BTMP := FALSE; // normally don't mute
IF PROXIMITY_SENSOR_ALARM_MUTE_FORCE.FORCED THEN
	BTMP := PROXIMITY_SENSOR_ALARM_MUTE_FORCE.DOUT_STATE;
END_IF
//BTMP := NOT BTMP; // Mute "ON" signal turns alarm speaker off, so if we want the alarm speaker off, we turn the mute output on, and vice versa
OUT_PROXIMITY_SENSOR_ALARM_MUTE(uiValue := TO_UINT(BTMP));

	
(* Proximity Antenna Control *)
(* must be active before rotaries can move *)

// turn on antenna when either rotary is activated
// only use when rotaries activated
IF isRotaryActive() OR TEST OR NOT PROXIMITY_SENSOR_PRESENCE_CONFIRMED THEN 
	BTMP := FALSE;
ELSE
	BTMP := TRUE;
END_IF
IF PROXIMITY_SENSOR_DISABLE_FORCE.FORCED THEN
	BTMP := PROXIMITY_SENSOR_DISABLE_FORCE.DOUT_STATE;
END_IF
//BTMP := NOT BTMP; // Antenna "ON" signal deactivates antenna, so if we want the proximity sensor antenna on, we turn the output off, and vice versa
OUT_PROXIMITY_SENSOR_DISABLE(uiValue := TO_UINT(BTMP));

TestVar6 := TO_BOOL(OUT_PROXIMITY_SENSOR_DISABLE.uiValue); // proximity antenna output on (antenna off)

LAST_PROXIMITY_SENSOR_CYCLE_WARNING := (PROXIMITY_SENSOR_ALARM_ON = PROXIMITY_SENSOR_ON_ALARM_OFF) AND pNVM4^.HMI_BOOLS[PROXIMITY_SENSOR_INSTALLED];

(*
don't let rotaries start until PROXIMITY_SENSOR_ON_ALARM_OFF detected
*)