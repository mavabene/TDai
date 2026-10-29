
(********************** Declaration ****************************)
METHOD screwDriveControl
VAR_INPUT
END_VAR
VAR
	VEL_PROCESS: REAL;
END_VAR

(********************** Implementation ****************************)
	LAST_CHECK_MS := MSTIME;
	
	DRIVE_CURRENT_EMBEDMENT := SCREW_START_POS - pLOWER_CROWD^.FEEDBACK.POSITION_ENGR - pNVM1^.SCREW_TIP_TO_GROUND;
	DRIVE_REMAINING := pLOWER_CROWD^.FEEDBACK.POSITION_ENGR - SCREW_END_POS;
	
	//debug
	TestVar3 := DRIVE_CURRENT_EMBEDMENT; // DRive current embedment

	// Calculate velocity setpoint here.  Three cases cause us to use UR to calculate LC velocity setpoint:
	//
	//	1) Machine setup for hard soil drilling (i.e. soft soil is *not* enabled.
	//	2) Machine is setup for soft soil drilling but had detected hard soil drilling.
	//	3) Machine is setup for soft soil drilling, and machine is detecting soft soil, and the user has selected that
	//		UR should be the control source for LC velocity setpoint.
	//
	// In general, if the soft soil bit protrusion for normal soft soil screw drive is positive (that is, bit is
	//		outside of the screw), then the velocity source should be UR.
	IF NOT pNVM4^.SOFT_SOIL_ENABLED OR HARD_SOIL_DETECTED THEN
		VEL_PROCESS := screwSpeedHardSoil();
	ELSE
		VEL_PROCESS := screwSpeedSoftSoil();
	END_IF
	LC_RAMPUP := FALSE;
	LOWER_CROWD_RAMP_DELTA := LOWER_CROWD_RAMP_START - pLOWER_CROWD^.FEEDBACK.POSITION_ENGR;
	IF UR_STALL_RECOVERY AND drillCurrentExtent() >= UR_STALL_FURTHEST_EXTENT THEN
		// We are recovering from a stall, and have the drill somewhere above the point where a pre-drill
		//	operation has happened.  In this situation, limit the velocity to the lowest screw drive velocity,
		//	as we know we are going to hit hard stuff very soon.
		VEL_SETPOINT_DESIRED := pNVM1^.LC_DRIVE_VEL_LOW;
	ELSIF DRIVE_RAMPUP_DISTANCE > 0 AND LOWER_CROWD_RAMP_DELTA < DRIVE_RAMPUP_DISTANCE THEN
		// We want to ramp to the process velocity to which we switch.
		VEL_SETPOINT_DESIRED := RAMPUP_MINIMUM_VEL + (LOWER_CROWD_RAMP_DELTA / DRIVE_RAMPUP_DISTANCE) * (VEL_PROCESS - RAMPUP_MINIMUM_VEL);
		LC_RAMPUP := TRUE;
	ELSIF DRIVE_REMAINING > RAMPDOWN_DISTANCE THEN
		VEL_SETPOINT_DESIRED := VEL_PROCESS;
		(* We will ramp at the end, and start from this to go to the minimum. This gets updated everytime through in
			the normal screw drive, but only used from the last moment before the rampdown starts. *)
		RAMPDOWN_START_VEL := DRIVE_VEL_SETPOINT;
	ELSE
		(* Scale velocity down from beginning of ramp setpoint velocity (based on pressure) to the lowest screw drive speed. *)
		IF DRIVE_REMAINING > 0 THEN
			VEL_SETPOINT_DESIRED := pNVM1^.LC_DRIVE_VEL_LOW + (DRIVE_REMAINING / RAMPDOWN_DISTANCE) * (RAMPDOWN_START_VEL - pNVM1^.LC_DRIVE_VEL_LOW);
		ELSE
			// We have gone past the calculated end of drive because we are waiting for the operator to say drive is complete.
			VEL_SETPOINT_DESIRED := pNVM1^.LC_DRIVE_VEL_LOW;
		END_IF
	END_IF

	(* Limit the acceleration by slewing from the current setpoint to the desired setpoint. *)
	IF VEL_SETPOINT_DESIRED > (DRIVE_VEL_SETPOINT + DRIVE_VEL_SLEW) THEN
		DRIVE_VEL_SETPOINT := DRIVE_VEL_SETPOINT + DRIVE_VEL_SLEW;
	ELSIF VEL_SETPOINT_DESIRED < (DRIVE_VEL_SETPOINT - DRIVE_VEL_SLEW) THEN
		DRIVE_VEL_SETPOINT := DRIVE_VEL_SETPOINT - DRIVE_VEL_SLEW;
	ELSE
		DRIVE_VEL_SETPOINT := VEL_SETPOINT_DESIRED;
	END_IF

	pLOWER_CROWD^.SETPOINT.VELOCITY_ENGR := DRIVE_VEL_SETPOINT;
	
	DRIVE_PWM_OUTPUT := -driveOutput(DRIVE_VEL_SETPOINT);

	// We always calculate drive velocity as a positive for operator convenience, then use
	//	the actual sign in the control loop.
	DRIVE_VEL_ERROR := -DRIVE_VEL_SETPOINT - LOWER_CROWD_VEL_SMOOTHED;
	(* Subtracts when vel too high, adds when vel too low. *)
	DRIVE_PWM_OUTPUT := DRIVE_PWM_OUTPUT + pNVM1^.DRIVE_KP * DRIVE_VEL_ERROR;
	(* Reduces ISUM when vel too high, adds when vel too low. *)
	DRIVE_ISUM := DRIVE_ISUM + DRIVE_VEL_ERROR * pNVM1^.DRIVE_KI_INTERNAL;
	IF DRIVE_ISUM > pNVM1^.DRIVE_ILIMIT THEN
		DRIVE_ISUM := pNVM1^.DRIVE_ILIMIT;
	ELSIF DRIVE_ISUM < -pNVM1^.DRIVE_ILIMIT THEN
		DRIVE_ISUM := -pNVM1^.DRIVE_ILIMIT;
	END_IF
	DRIVE_PWM_OUTPUT := DRIVE_PWM_OUTPUT + DRIVE_ISUM;

	IF DRIVE_PWM_OUTPUT < 0 THEN
		POSITIVE := FALSE;
	ELSE
		POSITIVE := TRUE;
	END_IF
	
	MAGNITUDE := TO_WORD(ABS(DRIVE_PWM_OUTPUT));
	
	// @TODO: smk - WTF is this for?
	IF MAGNITUDE > pNVM1^.DRIVE_OUTPUT_MAX THEN
		MAGNITUDE := TO_WORD(pNVM1^.DRIVE_OUTPUT_MAX);
	ELSIF MAGNITUDE < 5 THEN
		MAGNITUDE := TO_WORD(5);
	END_IF

	setOutput(ADR(pLOWER_CROWD^.OUTPUT), MAGNITUDE, POSITIVE);
