
(********************** Declaration ****************************)
METHOD ScrewStateNxtTlAdjust : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
//PNEZD_ADJUST_EASTING := CalcNxt1ThirdLegAdjustX();
IF FIRST_IN_LEVEL THEN
	FIRST_IN_LEVEL := FALSE;
	//GPS_ADJUST_EASTING := CalcThirdLegAdjustEasting();
	GPS_AUTOTARGET_ACTUATE := TRUE;
	GPS_TRUSS_CYCLE := GPS_FINE_SLOW_FEEDBACK_MOVE;
ELSE 
	confirmMonitorStart();
	GPS_AUTOTARGET_ACTUATE := FALSE;
	//IF (GPS_TRUSS_CYCLE = GPS_NO_MOVE) THEN
	IF 	(isNXTmotorThirdLeg_perLatch() AND GpsAutoAxesNearTarget_TLM(FALSE, FALSE, 1.0))
		OR // third leg will deflect rearward anyway, and we have some wiggle room, so allow it to proceed if x slide is maxed out and we are close
		(isNXTmotorThirdLeg_perLatch() AND GpsAxisNearTarget(GPS_HEADING, FALSE, FALSE, FALSE, 1.0) AND GpsAxisNearTarget(GPS_Y, TRUE, FALSE, FALSE, 
			1.0) AND (GPS_AXES[GPS_X].OFFSET > -100) AND (GPS_AXES[GPS_X].OFFSET < 0) AND AXES[AXIS_X_SLIDE].FEEDBACK.POSITION_ENGR > 29.8)
		OR
		GpsAutoAxesNearTarget(FALSE, FALSE, 1.3)
		OR // don't need to be very precise for high wp locating
		( (WP_HEIGHT_LATCH = WP_HIGH) AND GpsAutoAxesNearTarget(FALSE, FALSE, 2.0) )
		THEN // close enough, advance state
			setScrewModeState(SCREW_STATE_POSITION_MAST_SLIDE); 
// 				ELSIF NOT GpsAutoAxesNearTarget(FALSE, FALSE, 1, 0.9) THEN 
// 					FIRST_IN_LEVEL := TRUE;  // retry
		
// 			ELSIF GpsAutoAxesNearTarget(FALSE, FALSE, 1, 0.8) THEN
// 				GPS_TRUSS_CYCLE := GPS_NO_MOVE;
	ELSIF NOT AXES[AXIS_BOOM_SWING].LOOP_PID.SETTLED THEN
		setWaitingStrings('Boom swing', 'Boom swing');
	ELSIF NOT AXES[AXIS_YAW].LOOP_PID.SETTLED THEN
		setWaitingStrings('Yaw', 'Yaw');
	ELSIF NOT AXES[AXIS_X_SLIDE].LOOP_PID.SETTLED THEN
		setWaitingStrings('X slide', 'X slide');
	END_IF
	IF confirmRequested() THEN
		GPS_TRUSS_CYCLE := GPS_NO_MOVE;
		setScrewModeState(SCREW_STATE_POSITION_MAST_SLIDE);
	END_IF
END_IF 
