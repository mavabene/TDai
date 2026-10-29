
(********************** Declaration ****************************)
METHOD driveOutput : REAL
VAR_INPUT
	V: REAL;
END_VAR

(********************** Implementation ****************************)

// Running all out of the feedforward.
driveOutput := pNVM1^.DRIVE_KVFF * V;
// Valve deadband.
driveOutput := driveOutput + 30;
