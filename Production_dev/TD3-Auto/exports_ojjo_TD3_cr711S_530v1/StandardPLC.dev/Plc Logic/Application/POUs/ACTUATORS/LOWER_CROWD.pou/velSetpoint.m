
(********************** Declaration ****************************)
METHOD velSetpoint : REAL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF pNVM1^.UR_DRIVE_PRESSURE_LOW >= pNVM1^.UR_DRIVE_PRESSURE_HI THEN
	// Bogus setup, just use low speed.
	velSetpoint := pNVM1^.LC_DRIVE_VEL_LOW;
ELSIF UPPER_ROTARY_PRESSURE_FILTERED < pNVM1^.UR_DRIVE_PRESSURE_LOW THEN
	// Upper rotary pressure low, drive at max speed with lower crowd.
	velSetpoint := pNVM1^.LC_DRIVE_VEL_HI;
ELSIF UPPER_ROTARY_PRESSURE_FILTERED > pNVM1^.UR_DRIVE_PRESSURE_HI THEN
	// Upper rotary pressure high, drive at min speed with lower crowd.
	velSetpoint := pNVM1^.LC_DRIVE_VEL_LOW;
ELSE
	// Upper rotary pressure within process bounds, calculate speed at which to drive lower crowd.
	velSetpoint := pNVM1^.LC_DRIVE_VEL_HI -
		(UPPER_ROTARY_PRESSURE_FILTERED - pNVM1^.UR_DRIVE_PRESSURE_LOW)/(pNVM1^.UR_DRIVE_PRESSURE_HI - pNVM1^.UR_DRIVE_PRESSURE_LOW) *
		(pNVM1^.LC_DRIVE_VEL_HI - pNVM1^.LC_DRIVE_VEL_LOW);
END_IF
