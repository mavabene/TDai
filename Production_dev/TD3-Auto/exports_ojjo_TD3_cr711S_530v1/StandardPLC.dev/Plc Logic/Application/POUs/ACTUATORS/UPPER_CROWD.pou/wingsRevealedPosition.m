
(********************** Declaration ****************************)
(* Gives us the upper crowd position that will move the drill bit to where the wings are minimally revealed
	out the bottom of the currently selected screw. *)
METHOD wingsRevealedPosition : REAL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
wingsRevealedPosition := UPPER_CROWD_DRILL_TIP_FLUSH - pNVM1^.DRILL_BIT_LENGTH + pNVM3^.DRILL_BIT_WING_POSITION - WING_TO_SCREW_MINIMUM;