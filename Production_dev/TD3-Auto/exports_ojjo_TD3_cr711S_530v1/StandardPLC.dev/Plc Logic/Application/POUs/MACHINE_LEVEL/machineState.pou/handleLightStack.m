
(********************** Declaration ****************************)
METHOD handleLightStack
VAR_INPUT
END_VAR
VAR
	GPS_ON_TARGET_INDICATION_TOLERANCE_FACTOR_FINE: REAL := 0.6; // 0.8 so indication is more restrictive than actuation
	GPS_ON_TARGET_INDICATION_TOLERANCE_FACTOR_ROUGH: REAL := 0.8; // 0.8 so indication is more restrictive than actuation
END_VAR


(********************** Implementation ****************************)
(* Handle machine state light stack here. *)
BLINK_MODE(ENABLE := TRUE, TIMELOW := TIMELOW, TIMEHIGH := TIMEHIGH, OUT => BTMP);
IF BLUE_LIGHT_FORCE.FORCED THEN
	BTMP := BLUE_LIGHT_FORCE.DOUT_STATE;
END_IF
OUT_BLUE_LIGHT(uiValue := TO_UINT(BTMP));

IF MACHINE_MODE = ERROR_MODE THEN
	BTMP := 1;
ELSIF NOT REMOTE.AVAILABLE THEN
	BLINK_NO_REMOTE(ENABLE := TRUE, TIMELOW := T#100MS, TIMEHIGH := T#900MS, OUT => BTMP);
ELSE
	BTMP := 0;
END_IF
IF RED_LIGHT_FORCE.FORCED THEN
	BTMP := RED_LIGHT_FORCE.DOUT_STATE;
END_IF
OUT_RED_LIGHT(uiValue := TO_UINT(BTMP));

IF WARNING_CURRENT <> 0 THEN
	BTMP := TRUE;
ELSE
	BTMP := FALSE;
END_IF
IF YELLOW_LIGHT_FORCE.FORCED THEN
	BTMP := YELLOW_LIGHT_FORCE.DOUT_STATE;
END_IF
OUT_YELLOW_LIGHT(uiChannel := YELLOW_LIGHT_POINT, uiValue := TO_UINT(BTMP),
	xError => YELLOW_LIGHT_ERROR, eDiagInfo => YELLOW_LIGHT_DIAG, xPrepared => YELLOW_LIGHT_PREPARED, xOutState => YELLOW_LIGHT_ACTIVATED);

(* Blink if continue/confirm is requested. *)
IF MACHINE_MODE = ERROR_MODE THEN
	BTMP := FALSE;

// gps indications

// ready for operator:
ELSIF pNVM4^.GPS_AUTOTARGET_SELECTION.GPS_WP_AUTOTARGET_ON AND 
		(	
			(	// indicate when TD is within range to autotarget
				MACHINE_MODE = TRACK_MODE 
				AND TRACK_STATE = TRACK_STATE_NORMAL 
				AND GpsTargetInRangeIndication() 
				AND (	
						NOT pNVM4^.GPS_AUTOTARGET_SELECTION.GPS_3RD_LEG_X_ADJUST 
						OR
						// TODO expand these limits when bigger x slide cylinder used?  eg 5 and 25?
						(GPS_AXES[GPS_X].TARGET_POSITION > 5 AND GPS_AXES[GPS_X].TARGET_POSITION < 15)
					)
			) 
		OR
			// indicate TD is settled on target and ready to go to Screw Drive
			(	MACHINE_MODE = RWP_MODE 
				AND GPS_AUTOTARGET_STATUS.GPS_USED_THIS_TRUSS 
				AND	(	( 	(RWP_STATE = RWP_STATE_LOCATE_WP OR RWP_STATE = RWP_STATE_SQUARE_YAW) 
							AND GpsConfirmsWpOnTarget(FALSE, TRUE, 1.3) )
					OR
						(	(RWP_STATE = RWP_STATE_GPS_FINE_TARGET) 
							AND GpsConfirmsWpOnTarget(FALSE, TRUE, GPS_ON_TARGET_RWP) )
					)
			)
		OR
			// gps on target - ready to go to crimp 
			(	MACHINE_MODE = SCREW_MODE 
				AND (SCREW_STATE = SCREW_STATE_FWP) 
				AND GPS_AUTOTARGET_STATUS.GPS_USED_THIS_TRUSS 
				AND
				GpsAutoAxesNearTarget(TRUE, TRUE, GPS_ON_TARGET_INDICATION_TOLERANCE_FACTOR_FINE * pNVM4^.GPS_GENERAL_SETTINGS[GPS_TRANSITION_TO_CRIMP_FACTOR]) )
		OR
			// indicate within range for side legs so operator can skip tracking and go straight to rwp mode
			(	MACHINE_MODE = SCREW_MODE 
				AND SCREW_STATE = SCREW_STATE_LOAD_SCREW 
				AND getScrewSide() = eScrewSide.SCREW_RIGHT 
				AND pNVM4^.GPS_AUTOTARGET_SELECTION.GPS_3RD_LEG_X_ADJUST 
				AND isNXTmotorTruss_perScrewParams() 
				AND GpsTargetInRangeActual() )
	)
	THEN
	//GPS_IN_RANGE_INTERVAL := UDINT_TO_TIME(TIME_TO_UDINT(T#100MS) * TO_UDINT ( GPS_AXES[GPS_X].OFFSET / 150 ) );
	BLINK_NO_TOUCH(ENABLE := TRUE, TIMELOW := GPS_IN_RANGE_INTERVAL, TIMEHIGH := GPS_IN_RANGE_INTERVAL, OUT => BTMP);
// waiting on autotarget:
ELSIF pNVM4^.GPS_AUTOTARGET_SELECTION.GPS_WP_AUTOTARGET_ON AND (GPS_TRUSS_CYCLE <> GPS_NO_MOVE) THEN
	BLINK_NO_TOUCH(ENABLE := TRUE, TIMELOW := (T#1000MS - GPS_IN_RANGE_INTERVAL), TIMEHIGH := GPS_IN_RANGE_INTERVAL, OUT => BTMP);	
ELSIF confirmMonitorEnabled() THEN
	BLINK_NO_TOUCH(ENABLE := TRUE, TIMELOW := T#100MS, TIMEHIGH := T#900MS, OUT => BTMP);
ELSIF MACHINE_NO_TOUCH THEN
	BLINK_NO_TOUCH(ENABLE := TRUE, TIMELOW := T#50MS, TIMEHIGH := T#50MS, OUT => BTMP);
ELSIF NOT AUTOMATIC THEN
	// Let the operator know we are in manual operation.
	BLINK_MANUAL(ENABLE := TRUE, TIMELOW := T#900MS, TIMEHIGH := T#50MS, OUT => BTMP);
ELSE
	BTMP := TRUE;
END_IF

IF GREEN_LIGHT_FORCE.FORCED THEN
	BTMP := GREEN_LIGHT_FORCE.DOUT_STATE;
END_IF
OUT_GREEN_LIGHT(uiValue := TO_UINT(BTMP));

