
(********************** Declaration ****************************)
(* Gives us the upper crowd position required to get the drill bit reveal from the current screw to
	the optimal drilling position. *)
METHOD finalDrillPosition : REAL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
finalDrillPosition := UPPER_CROWD_DRILL_TIP_FLUSH - pNVM1^.DRILL_BIT_DRIVE_PROTRUSION;
