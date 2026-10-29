
(********************** Declaration ****************************)
METHOD prepareForReturn
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// Mark for all the actuator code that we are exiting screw drive, but are
//	preparing to return.
RETURNING_TO_DRIVE := TRUE;

UC_RETURN_POS := AXES[AXIS_UPPER_CROWD].FEEDBACK.POSITION_ENGR;
