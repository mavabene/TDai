
(********************** Declaration ****************************)
METHOD ScrewStateMastToTarget : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF isPauseRequested() THEN
	(* Just change the pause/continue state here *)
	setPaused(NOT SCREW_MODE_PAUSED, ADR(SCREW_MODE_PAUSED), ADR(SCREW_MODE_PAUSED_CHANGE));
END_IF

IF NOT SCREW_MODE_PAUSED THEN
	(* Wait for the axes to complete moving to the screw drive start position. *)
	ROTATOR_MONITOR(INIT := FALSE, MSTIME := MSTIME, pAXIS := ADR(AXES[AXIS_ROTATOR]),
		FOR_MS := 250, WITHIN := AXES[AXIS_ROTATOR].LOOP_PID.SETTLED_BAND, DONE => ROTATOR_SETTLED);
	IF ( ROTATOR_SETTLED = TRUE AND
		AXES[AXIS_UPPER_CROWD].LOOP_PID.SETTLED = TRUE AND
		AXES[AXIS_LOWER_CROWD].LOOP_PID.SETTLED = TRUE AND
		(
			NOT isNXTmotorThirdLeg_perLatch() OR
				(
				// On the NXT 3LM truss, the EW and NS screws both move certain axes to get into
				//	screw drive positions.  We need to wait for these to settle before we go on
				//	to drive screws.
				(AXES[AXIS_PITCH].LOOP_PID.SETTLED OR SCREW_SIDE_LATCH <> eScrewSide.SCREW_CENTER) AND
				(AXES[AXIS_BOOM_SWING].LOOP_PID.SETTLED OR SCREW_SIDE_LATCH = eScrewSide.SCREW_CENTER) AND
				(AXES[AXIS_YAW].LOOP_PID.SETTLED OR SCREW_SIDE_LATCH = eScrewSide.SCREW_CENTER) AND
				(AXES[AXIS_X_SLIDE].LOOP_PID.SETTLED OR SCREW_SIDE_LATCH = eScrewSide.SCREW_CENTER) AND
				(AXES[AXIS_Z_SLIDE].LOOP_PID.SETTLED)
				)
			)
		) 
		THEN
	
			IF GPS_AUTOTARGET_STATUS.GPS_USED_THIS_TRUSS AND 
				(		
					(pNVM4^.GPS_AUTOTARGET_SELECTION.GPS_3RD_LEG_X_ADJUST AND GPS_THIRD_LEG_ADJUST_ON) 
					OR
					(WP_HEIGHT_LATCH = WP_HIGH) 
					OR isNXTmotorThirdLeg_perLatch()
				)
				THEN
				(* High workpoint turns the rotator only, doesn't orient it in Y and Z. *)
				FIRST_IN_LEVEL := TRUE;
				setScrewModeState(SCREW_STATE_NXT_TL_ADJUST);
			ELSIF (WP_HEIGHT_LATCH = WP_NONE) THEN
				(* High workpoint turns the rotator only, doesn't orient it in Y and Z. *)
				setScrewModeState(SCREW_STATE_POSITION_MAST_SLIDE);
			ELSE
				(* Low workpoint orients as well as turns the rotator. *)
				IF (AXES[AXIS_BOOM_SWING].LOOP_PID.SETTLED = TRUE AND
					AXES[AXIS_Z_SLIDE].LOOP_PID.SETTLED = TRUE)
					THEN
						setScrewModeState(SCREW_STATE_POSITION_MAST_SLIDE);
				END_IF
			END_IF
	ELSIF NOT (AXES[AXIS_ROTATOR].LOOP_PID.SETTLED = TRUE) THEN
		setWaitingStrings('Rotator', 'Rotator');
	ELSIF NOT (AXES[AXIS_UPPER_CROWD].LOOP_PID.SETTLED = TRUE) THEN
		setWaitingStrings('Upper crowd', 'Upper crowd');
	ELSIF NOT (AXES[AXIS_LOWER_CROWD].LOOP_PID.SETTLED = TRUE) THEN
		setWaitingStrings('Lower crowd', 'Lower crowd');
	ELSIF NOT AXES[AXIS_PITCH].LOOP_PID.SETTLED AND isNXTmotorThirdLeg_perLatch() THEN
		setWaitingStrings('Pitch', 'Pitch');
	ELSIF NOT AXES[AXIS_BOOM_SWING].LOOP_PID.SETTLED AND isNxt3lmSideLeg_perLatch() THEN
		setWaitingStrings('Boom swing', 'Boom swing');
	ELSIF NOT AXES[AXIS_YAW].LOOP_PID.SETTLED AND isNxt3lmSideLeg_perLatch() THEN
		setWaitingStrings('Yaw', 'Yaw');
	ELSIF NOT AXES[AXIS_X_SLIDE].LOOP_PID.SETTLED AND isNxt3lmSideLeg_perLatch() THEN
		setWaitingStrings('X slide', 'X slide');
	ELSIF NOT AXES[AXIS_Z_SLIDE].LOOP_PID.SETTLED AND isNXTmotorTruss_perScrewParams() THEN
		setWaitingStrings('Z slide', 'Z slide');
	END_IF
ELSE
	setWaitingStrings('Operator', 'Operator');
END_IF

IF isContinueRequested() THEN
	(* Just change the pause/continue state here *)
	setPaused(NOT SCREW_MODE_PAUSED, ADR(SCREW_MODE_PAUSED), ADR(SCREW_MODE_PAUSED_CHANGE));
END_IF
// testing
IF SIM_SCREW_DRIVE_DONE THEN
	setScrewModeState(SCREW_STATE_MAST_TO_VERTICAL);
END_IF