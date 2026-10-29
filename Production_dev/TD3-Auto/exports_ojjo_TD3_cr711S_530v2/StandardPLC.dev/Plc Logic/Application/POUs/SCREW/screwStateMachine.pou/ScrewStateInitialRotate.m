
(********************** Declaration ****************************)
METHOD ScrewStateInitialRotate : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF FIRST_IN_LEVEL THEN
	
	IF isScrewModeGpsAdjustNeeded() THEN
		GPS_AUTOTARGET_ACTUATE := TRUE;
		GPS_TRUSS_CYCLE := GPS_SLOW_TRAPEZOID_MOVE;
	END_IF
ELSE 
	GPS_AUTOTARGET_ACTUATE := FALSE;
END_IF
 
IF isPauseRequested() THEN
	(* Just change the pause/continue state here *)
	setPaused(NOT SCREW_MODE_PAUSED, ADR(SCREW_MODE_PAUSED), ADR(SCREW_MODE_PAUSED_CHANGE));
END_IF

confirmMonitorStart();
IF confirmRequested() THEN
	CONFIRM_EARLY := TRUE;
	setScrewModeState(SCREW_STATE_LOAD_SCREW);
ELSIF NOT SCREW_MODE_PAUSED and not FIRST_IN_LEVEL THEN
	(* This state was added because sometimes screw drive automatic gets entered with the drill bit
		in the ground, or in an already driven screw.  As a result, we wait for the above state to pull
		everything up out of the ground, then here we run the rotator.
	
		For the NXT three legged motor truss, we want to move the pitch here as well.  The case will
		happen where the operator gets partway into screw drive, so that mast is pitched forward for the
		third leg, then they will go to Manual and then Auto, and this needs to move the pitch back to the
		nominal row pitch.  This also wants to wait until the drill is out of the ground!
	*)
	IF (ABS(AXES[AXIS_ROTATOR].LOOP_PID.PERR_ENGR) < 1) 
		AND
		(
			NOT (isNXTmotorThirdLeg_perLatch() OR (WP_HEIGHT_LATCH = WP_HIGH) )
			OR
			(
				// Several axes are used on the NXT 3 legged motor truss:
				//	- Pitch only moves on NS screw
				//	- X slide and boom swing only move on EW screws
				//	- Z slide moves both on NS and EW screws
				AXES[AXIS_PITCH].LOOP_PID.SETTLED AND // OR SCREW_SIDE_LATCH <> eScrewSide.SCREW_CENTER) AND
				(AXES[AXIS_BOOM_SWING].LOOP_PID.SETTLED OR (WP_HEIGHT_LATCH <> WP_HIGH)) AND // OR SCREW_SIDE_LATCH = eScrewSide.SCREW_CENTER) AND
				(AXES[AXIS_YAW].LOOP_PID.SETTLED OR (WP_HEIGHT_LATCH <> WP_HIGH)) AND // OR SCREW_SIDE_LATCH = eScrewSide.SCREW_CENTER) AND
				AXES[AXIS_X_SLIDE].LOOP_PID.SETTLED AND // OR SCREW_SIDE_LATCH = eScrewSide.SCREW_CENTER) AND
				AXES[AXIS_Z_SLIDE].LOOP_PID.SETTLED
			)
		)
		AND
		( 
			NOT HMI_BOOLS_VALUES[PRELOAD_AUTO_MAST_LEAN_COMPENSATION] OR 
			(
				(AXES[AXIS_PITCH].LOOP_PID.SETTLED AND
				AXES[AXIS_X_SLIDE].LOOP_PID.SETTLED)
			)
		) 
		THEN
		CONFIRM_EARLY := FALSE;
		setScrewModeState(SCREW_STATE_LOAD_SCREW);
	ELSIF NOT (ABS(AXES[AXIS_ROTATOR].LOOP_PID.PERR_ENGR) < 1) THEN
		setWaitingStrings('Rotator', 'Rotator');
	ELSIF NOT AXES[AXIS_PITCH].LOOP_PID.SETTLED AND (isNXTmotorThirdLeg_perLatch() OR HMI_BOOLS_VALUES[PRELOAD_AUTO_MAST_LEAN_COMPENSATION])  THEN
		setWaitingStrings('Pitch', 'Pitch');
	ELSIF NOT AXES[AXIS_BOOM_SWING].LOOP_PID.SETTLED AND (isNxt3lmSideLeg_perLatch() OR (WP_HEIGHT_LATCH = WP_HIGH)) THEN
		setWaitingStrings('Boom swing', 'Boom swing');
	ELSIF NOT AXES[AXIS_YAW].LOOP_PID.SETTLED AND (isNxt3lmSideLeg_perLatch() OR (WP_HEIGHT_LATCH = WP_HIGH))THEN
		setWaitingStrings('Yaw', 'Yaw');
	ELSIF NOT AXES[AXIS_X_SLIDE].LOOP_PID.SETTLED AND (isNxt3lmSideLeg_perLatch() OR (WP_HEIGHT_LATCH = WP_HIGH) OR HMI_BOOLS_VALUES[PRELOAD_AUTO_MAST_LEAN_COMPENSATION]) THEN
		setWaitingStrings('X slide', 'X slide');
	ELSIF NOT AXES[AXIS_Z_SLIDE].LOOP_PID.SETTLED AND isNXTmotorTruss_perScrewParams() THEN
		setWaitingStrings('Z slide', 'Z slide');
	END_IF
ELSE
	(* Simply paused, do nothing. *)
	;
END_IF

IF isContinueRequested() THEN
	(* Just change the pause/continue state here *)
	setPaused(NOT SCREW_MODE_PAUSED, ADR(SCREW_MODE_PAUSED), ADR(SCREW_MODE_PAUSED_CHANGE));
END_IF

FIRST_IN_LEVEL := FALSE;