
(********************** Declaration ****************************)
METHOD handleAudibleAlarms
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF  HYDRAULIC_TEMP > HYDRAULIC_TEMP_HORN THEN
	// Strong warnings for the operator to do something!
	BLINK_HORN(ENABLE := TRUE, TIMELOW := T#1800MS, TIMEHIGH := T#200MS, OUT => BTMP);
// ELSIF MACHINE_MODE = SCREW_MODE AND  // *** this is never true now that we use gps ***
// 	(SCREW_STATE = SCREW_STATE_DRIVE_SCREW OR SCREW_STATE = SCREW_STATE_DRIVE_ASSIST) AND
// 	(
// 		// Manual depth can be overridder in two cases:
// 		//	- Operator is setup for end truss
// 		//	- Install process is using laser on motor mount.
// 		pNVM3^.MANUAL_DEPTH AND NOT
// 		trussUsingGPS_alwaysTrue() // *** this is never true now that we use gps ***
// 	) AND
// 	(
// 		(AXES[AXIS_LOWER_CROWD].FEEDBACK.POSITION_ENGR <= CROWD_EMBED_ENDPOINT) OR
// 		((pNVM3^.EMBED_REDUCTION_ENABLED OR
// 						(pNVM4^.HMI_BOOLS[SCREW_PARAMS_SOURCE_IS_PNEZD] AND 
// 						 SCREW_PARAMETERS_CURRENT.IE_MIN_HAMMER <> NA AND 
// 						 SCREW_PARAMETERS_CURRENT.IE_MIN_EMBED <> NA)) 
// 
// 		AND EMBED_REDUCTION_DETECTED AND NOT (TRUSS_TYPE_LATCH = eTrussType.TRUSS_TYPE_CENTER_STRUCTURE))
// 	) THEN
// 	// We are at the point in screw drive where the operator is allowed to stop screw drive.  Let the operator know
// 	//	this is the case.
// 	BLINK_HORN(ENABLE := TRUE, TIMELOW := T#900MS, TIMEHIGH := T#300MS, OUT => BTMP);
ELSIF HORN_REQUEST_TIMES > 0 THEN
	BLINK_HORN(ENABLE := TRUE, TIMELOW := HORN_REQUEST_OFF, TIMEHIGH := HORN_REQUEST_ON, OUT => BTMP);
	// If we go from on to off state of the horn, decrement the count.
	IF HORN_REQUEST_LAST_STATE AND NOT BTMP THEN
		HORN_REQUEST_TIMES := HORN_REQUEST_TIMES - 1;
	END_IF
	HORN_REQUEST_LAST_STATE := BTMP;
ELSE
	BLINK_HORN(ENABLE := FALSE);
	BTMP := FALSE;
END_IF

IN_HORN_BUTTON(uiCHANNEL := HORN_BUTTON_POINT, eMode := ifmIOCommon.MODE_INPUT.IN_DIGITAL_CSI, xValueDigital => HORN_BUTTON, eDiagInfo => HORN_BUTTON_DIAG);
IF HORN_FORCE.FORCED THEN
	BTMP := HORN_FORCE.DOUT_STATE;
ELSIF HORN_BUTTON THEN
	// Someone is pressing down the button.
	BTMP := TRUE;
END_IF
OUT_HORN1(uiValue := TO_UINT(BTMP));
OUT_HORN2(uiValue := TO_UINT(BTMP));

(* Handle the audible alarm.  Note that many warnings only flash the light and don't sound the audible alarm.  Also note,
	if Pump 1 pressure is very low, the engine is not running, so no need to blink. *)
WARNING_HORN_MASK := TO_DWORD(eWarningCauseMask.BASE_PITCH) OR TO_DWORD(eWarningCauseMask.BASE_ROLL) OR TO_DWORD(eWarningCauseMask.PITCH) OR TO_DWORD(eWarningCauseMask.ROTATOR)
	OR TO_DWORD(eWarningCauseMask.COMPRESSOR);

(* The fuel level causes warning with no horn first, then as fuel gets lower it adds the horn. *)
IF ((WARNING_HORN_MASK AND WARNING_CURRENT) <> 0) AND (TIME_SECONDS > 10)
	AND (PUMP_PRESSURE > 100) THEN
	BLINK_TRAVEL_ALARM(ENABLE := TRUE, TIMELOW := T#900MS, TIMEHIGH := T#100MS, OUT => BTMP);
ELSIF MACHINE_MODE = TRACK_MODE THEN
	IF AXES[AXIS_TRACK_LEFT].OUTPUT.MAGNITUDE <> 0 OR AXES[AXIS_TRACK_RIGHT].OUTPUT.MAGNITUDE <> 0 THEN
		BLINK_TRAVEL_ALARM(ENABLE := TRUE, TIMELOW := T#800MS, TIMEHIGH := T#200MS, OUT => BTMP);
	ELSE
		BLINK_TRAVEL_ALARM(ENABLE := FALSE);
		BTMP := 0;
	END_IF
ELSE
	BLINK_TRAVEL_ALARM(ENABLE := FALSE);
	BTMP := 0;
END_IF

IF TRAVEL_ALARM_FORCE.FORCED THEN
	BTMP := TRAVEL_ALARM_FORCE.DOUT_STATE;
END_IF
OUT_TRAVEL_ALARM(uiValue := TO_UINT(BTMP));

