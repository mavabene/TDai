
(********************** Declaration ****************************)
(* Gives the furthest drill ahead position of the upper crowd.  THis leaves a very small amount of the bit
	in the currently selected screw, which prevents the bit from hanging up on the bottom of the screw when the
	upper crowd reverses. *)
METHOD drillAheadPosition : REAL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// Preferably, we will use almost all of the drill bit between the top of the wing and the top of the chuck
//	to give us room to drill ahead with.
drillAheadPosition := UPPER_CROWD_DRILL_TIP_FLUSH - pNVM1^.DRILL_BIT_LENGTH + DRILL_IN_SCREW_MINIMUM;

// If using the bit as described above causes us to run out of drill steel (as evidenced by the upper crowd
//	wanting to hit the lower crowd), limit the drill ahead to the lower command limit of the upper crowd.
IF drillAheadPosition < AXES[AXIS_UPPER_CROWD].CONFIG.COMMAND_LIMIT_MIN THEN
	drillAheadPosition := AXES[AXIS_UPPER_CROWD].CONFIG.COMMAND_LIMIT_MIN;
END_IF
