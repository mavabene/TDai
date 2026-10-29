
(********************** Declaration ****************************)
METHOD reduceEmbedment
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// If we get here, the embedment reduction code has determined that we don't need to drive further.  We want to
//	see if we can use a shorter leg, and if so, we want to pull in the end of screw drive position.
DRIVE_REMAINING := pLOWER_CROWD^.FEEDBACK.POSITION_ENGR - SCREW_END_POS;
// This is how much we reduced embedment compared to the structural minimum embedment constraint.
EMBEDMENT_REDUCTION_STRUCTURAL := DRIVE_REMAINING;
FOUND := FALSE;

// ************************
IF LEG_LENGTH_ACTUAL = 0 THEN
	LEG_LENGTH_EMBED := DRIVE_CURRENT_EMBEDMENT;
	FOR INDEX := 1 TO LEG_LENGTHS_COUNT DO
		(* Go from shortest to longest leg, searching for a length greater than
			what we would like. *)
		IF pNVM2^.LEG_LENGTH_USED[INDEX] AND pNVM2^.LEG_LENGTHS_CM[INDEX] > LEG_LENGTH_EMBED THEN
			LEG_LENGTH_ACTUAL := pNVM2^.LEG_LENGTHS_CM[INDEX];
			EXIT;
		END_IF
	END_FOR
END_IF

// ************************

FOR INDEX := 1 TO (LEG_BIN - 1) DO
	// We know that we use the leg length denoted by LEG_BIN if we drive to SCREW_END_POS.  Is there enough
	//	distance between here and the end to allow us to stop early and use a shorter leg?
	EMBEDMENT_REDUCTION := LEG_LENGTH_ACTUAL - pNVM2^.LEG_LENGTHS_CM[INDEX];
	IF (pNVM2^.LEG_LENGTH_USED[INDEX] AND DRIVE_REMAINING > EMBEDMENT_REDUCTION) THEN
		(* Found a leg, exit the for loop. *)
		FOUND := TRUE;
		// This is the shortest leg we can use, saving the most drive time.  Change the leg length...
		LEG_LENGTH_ACTUAL := pNVM2^.LEG_LENGTHS_CM[INDEX];
		LEG_BIN := INDEX;
		
		// Now adjust the dynamic values of the calculation.
		SCREW_END_POS := SCREW_END_POS + EMBEDMENT_REDUCTION;
		DRIVE_LEG_LENGTH := LEG_LENGTH_ACTUAL;
		DRIVE_TARGET_EMBEDMENT := DRIVE_TARGET_EMBEDMENT - EMBEDMENT_REDUCTION;
		DRIVE_LEG_REVEAL := DRIVE_LEG_REVEAL + EMBEDMENT_REDUCTION;
		
		EXIT;
	END_IF
END_FOR
