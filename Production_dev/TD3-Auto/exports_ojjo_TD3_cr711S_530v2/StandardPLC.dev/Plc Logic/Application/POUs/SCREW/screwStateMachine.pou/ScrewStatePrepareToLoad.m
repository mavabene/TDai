
(********************** Declaration ****************************)
METHOD ScrewStatePrepareToLoad : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF isPauseRequested() THEN
	(* Just change the pause/continue state here *)
	setPaused(NOT SCREW_MODE_PAUSED, ADR(SCREW_MODE_PAUSED), ADR(SCREW_MODE_PAUSED_CHANGE));
END_IF

confirmMonitorStart();
IF confirmRequested() THEN
	CONFIRM_EARLY := TRUE;
	setScrewModeState(SCREW_STATE_LOAD_SCREW);
	FIRST_IN_LEVEL := TRUE;
ELSIF NOT SCREW_MODE_PAUSED THEN
	(* Wait for the axes to complete moving to the load position.  We want the mast slide
		to be in a fixed position off the ground when level, the lower crowd to be at a height
		based on the screw length, the upper crowd oriented to have the mandrel tip sticking
		out through the screw, and the rotator having the mast levelled.  This assures that
		the height of the chuck is not a function of workpoint, only screw length.  Note tolerances
		are wide, as this is not tolerance critical, just wait until we get close!
	*)
	IF ((ABS(AXES[AXIS_MAST_SLIDE].LOOP_PID.PERR_ENGR) < 1)
		AND (ABS(AXES[AXIS_LOWER_CROWD].LOOP_PID.PERR_ENGR) < 1)
		AND (ABS(AXES[AXIS_UPPER_CROWD].LOOP_PID.PERR_ENGR) < 1)
		) THEN
		CONFIRM_EARLY := FALSE;
		FIRST_IN_LEVEL := TRUE;
		setScrewModeState(SCREW_STATE_INITIAL_ROTATE);
	ELSIF NOT (ABS(AXES[AXIS_MAST_SLIDE].LOOP_PID.PERR_ENGR) < 1) THEN
		setWaitingStrings('Mast slide', 'Mast slide');
	ELSIF NOT (ABS(AXES[AXIS_LOWER_CROWD].LOOP_PID.PERR_ENGR) < 1) THEN
		setWaitingStrings('Lower crowd', 'Lower crowd');
	ELSIF NOT (ABS(AXES[AXIS_UPPER_CROWD].LOOP_PID.PERR_ENGR) < 1) THEN
		setWaitingStrings('Upper crowd', 'Upper crowd');
	END_IF
END_IF

IF isContinueRequested() THEN
	(* Just change the pause/continue state here *)
	setPaused(NOT SCREW_MODE_PAUSED, ADR(SCREW_MODE_PAUSED), ADR(SCREW_MODE_PAUSED_CHANGE));
END_IF