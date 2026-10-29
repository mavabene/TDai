
(********************** Declaration ****************************)
METHOD onScrewDriveStart
VAR_INPUT
END_VAR
VAR
	MAST_FOOT_EDGE_TO_SCREW_CENTER_X: REAL := 21.3 * 2.54; // with mast foot on ground, distance from forward mast foot edge to center of screw
	MAST_FOOT_EDGE_TO_SCREW_CENTER_Y: REAL := 12.08 * 2.54; // "" distance from side of mast foot to center of screw
	STANDARD_SIDE_LEG_ANGLE: REAL := 20;
	SCREW_TIP_TO_GROUND_NXT_SIDE: REAL := 0;
	OFFSET_FROM_CENTER_OF_MAST_FOOT_TO_SCREW_TIP: REAL := 0;
	
	
	
END_VAR
(********************** Implementation ****************************)
(* Latch the position where the upper crowd starts.  We want to go to a level consistent with
	the screw being driven to depth. *)
SCREW_DRIVE_DONE := FALSE;
SCREW_START_POS := pLOWER_CROWD^.FEEDBACK.POSITION_ENGR;
BASE_PITCH_START := BASE_ROLL_FILTERED_FAST;
BASE_PITCH_END := 0.0;
KNUCKLE_PITCH_START := AXES[AXIS_PITCH].FEEDBACK.POSITION_ENGR;
KNUCKLE_PITCH_END := 0.0;
MANDREL_PITCH_ERROR := 0.0;

DRIVE_MAX_LC_PRESSURE := 0;
DRIVE_MAX_LR_PRESSURE := 0;
DRIVE_MAX_LR_TORQUE := 0;
DRIVE_MAX_UC_PRESSURE := 0;
DRIVE_MAX_UR_PRESSURE := 0;


(* The first constraint is minimum screw embedment, measured relative from the tip
	of the screw.  We are sitting with the mast foot on the ground and the screw poised to
	go in.  Calculate the minimum insertion depth that is needed by the crowd so that
	we get the minimum required screw embedment. *)
	
setScrewParameters();
IF SCREW_SIDE_LATCH = SCREW_CENTER AND NOT isNXTmotorThirdLeg_perLatch() THEN
	// Plumb screw in situ comes here.
	CROWD_ADVANCE_MIN := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH;
ELSE
	IF isNXTmotorTruss_perScrewParams() THEN
		OFFSET_FROM_CENTER_OF_MAST_FOOT_TO_SCREW_TIP := MAST_FOOT_EDGE_TO_SCREW_CENTER_Y * TAN_DEG(pNVM1^.ROTATOR_SCREW_POS) - pNVM1^.SCREW_TIP_TO_GROUND;
		IF isNXTmotorThirdLeg_perLatch() THEN
			SCREW_TIP_TO_GROUND_NXT_3LM_NS := MAST_FOOT_EDGE_TO_SCREW_CENTER_X * TAN_DEG(CORRECTED_MAST_PITCH) 
											  - OFFSET_FROM_CENTER_OF_MAST_FOOT_TO_SCREW_TIP;								
			// Screw tip to ground in this configuration.
			CROWD_ADVANCE_MIN := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH + SCREW_TIP_TO_GROUND_NXT_3LM_NS;
		ELSE // motor side legs
			SCREW_TIP_TO_GROUND_NXT_SIDE := MAST_FOOT_EDGE_TO_SCREW_CENTER_Y * 
											TAN_DEG(SCREW_PARAMETERS_CURRENT.TRUSS_SIDE_LEG_ANGLE)//TAN_DEG(AXES[AXIS_ROTATOR].FEEDBACK.POSITION_ENGR)
											- OFFSET_FROM_CENTER_OF_MAST_FOOT_TO_SCREW_TIP;	
			CROWD_ADVANCE_MIN := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH + SCREW_TIP_TO_GROUND_NXT_SIDE;
		END_IF
	ELSE
		// Normal E/W screws here.
		CROWD_ADVANCE_MIN := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH + (pNVM1^.SCREW_TIP_TO_GROUND / COS_DEG(SCREW_PARAMETERS_CURRENT.NS_PITCH));
	END_IF
	// All screws have same drive depth tolerance.
	CROWD_ADVANCE_MIN := CROWD_ADVANCE_MIN + DRIVE_DEPTH_TOLERANCE;
	(*
ELSE
	IF isNxt3lm3lScrew() THEN
		SCREW_TIP_TO_GROUND_NXT_3LM_NS := 	  MAST_FOOT_EDGE_TO_SCREW_CENTER_X * TAN_DEG(CORRECTED_MAST_PITCH) 
											- MAST_FOOT_EDGE_TO_SCREW_CENTER_Y * TAN_DEG(STANDARD_SIDE_LEG_ANGLE) 
											+ pNVM1^.SCREW_TIP_TO_GROUND;
																				
		// Screw tip to ground in this configuration.`
		CROWD_ADVANCE_MIN := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH + SCREW_TIP_TO_GROUND_NXT_3LM_NS;
	ELSE
		// Normal E/W screws here.
		CROWD_ADVANCE_MIN := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH + pNVM1^.SCREW_TIP_TO_GROUND;
	END_IF
	// All screws have same drive depth tolerance.
	CROWD_ADVANCE_MIN := CROWD_ADVANCE_MIN + DRIVE_DEPTH_TOLERANCE;
	*)
END_IF
(* Calculate the crowd endpoint based on minimum embedment. *)
CROWD_EMBED_ENDPOINT := pLOWER_CROWD^.FEEDBACK.POSITION_ENGR - CROWD_ADVANCE_MIN;

IF CROWD_EMBED_ENDPOINT < LOWER_CROWD_MIN_END_POS THEN
	(* Error, we cannot drive to minimum embedment because of restriction on lower crowd motion! *)
	ERROR := TRUE;
	gotoErrorState(REASON := 'Cannot drive screw to minimum embedment, LC range!');
	RETURN;
END_IF

IF SCREW_SIDE_LATCH = SCREW_CENTER AND NOT isNXTmotorThirdLeg_perLatch() THEN
	(* Plumb screws come here.  This is simple, as we are simply driving to embedment.  This means that
		SCREW_END_POS has no constraints other than embedment, so we don't adjust here.  Note that we don't
		even care where the target plate is, as the laser is not considered.  Embedment is the ONLY constraint. *)
	LEG_OVERDRIVE := 0;
	SCREW_END_POS := CROWD_EMBED_ENDPOINT;
	DRIVE_LEG_LENGTH := 0;
	
	DRIVE_SCREW_LENGTH := SCREW_PARAMETERS_CURRENT.SCREW_LENGTH;
	DRIVE_MINIMUM_EMBEDMENT := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH;
	DRIVE_TARGET_EMBEDMENT := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH;
	DRIVE_LEG_REVEAL := SCREW_PARAMETERS_CURRENT.SCREW_LENGTH - DRIVE_TARGET_EMBEDMENT;
	
ELSE
	(* Array screws come here.  This has a bunch of complication for various reasons. *)

	(* The second constraint is distance between the screw top and workpoint after drive.  The workpoint
		target is located at the center of the rotator.  We stack up the measurement of the
		screw top from the rotator center as follows:

		1) The chuck reference surface is offset from the workpoint target by CHUCK_TO_TARGET.
		2) The operator jogs the mast slide down to the ground.
		3) The lower crowd will move between the workpoint setup and the end of driving.

	Once we add these up, we know how far the reference surface of the screw is from the rotator center
		if the screw is driven to the point of minimum embedment.  If we had infinitely variable leg
		lengths, we could just drive to here.

	*)
	(* Recall that the mast slide has been extended to touch the ground before this point, so that has actually
		been "driving" the screw through air away from the workpoint position. *)
	OPERATOR_MS_ADJUST := (MAST_SLIDE_AT_WP - AXES[AXIS_MAST_SLIDE].FEEDBACK.POSITION_ENGR);
	
	IF isNXTmotorThirdLeg_perLatch() THEN
		(* Pitch motion on N/S screw moves screw reference surface relative to workpoint. *)
		DELTA_EMBEDMENT := nxt3lmNsDeltaEmbed();
		OPERATOR_MS_ADJUST := OPERATOR_MS_ADJUST - DELTA_EMBEDMENT + (Z_SLIDE_AT_WP - AXES[AXIS_Z_SLIDE].FEEDBACK.POSITION_ENGR);
	END_IF
	
	(* Calculate the position of the lower crowd when the screw reference surface is at the
		workpoint.  That is, if the lower crowd is in this position, the laser is right on
		the screw reference surface. *)
	LC_W_REF_AT_WP := LOWER_CROWD_AT_WP + pNVM1^.CHUCK_TO_TARGET + OPERATOR_MS_ADJUST;

	(* Now, how far does the lower crowd have to move to get the screw reference surface
		from the workpoint to the minimum embedment? *)
	SCREW_REF_FROM_WP_EMBED := LC_W_REF_AT_WP - CROWD_EMBED_ENDPOINT;

	IF WP_HEIGHT_LATCH = WP_LOW THEN
		(* We have moved the rotator to drive the screw.  For workpoints below our lowest normal
			version, this will pull the screw back toward to workpoint, decreasing the distance
			between the . *)
		SCREW_REF_FROM_WP_EMBED := SCREW_REF_FROM_WP_EMBED + LOW_WP_ADJUST;
	ELSIF WP_HEIGHT_LATCH = WP_HIGH THEN // subtract the negative to add
		SCREW_REF_FROM_WP_EMBED := SCREW_REF_FROM_WP_EMBED - HIGH_WP_SIDE_LEG_AXIS_REDUCTION;
	END_IF

	(* The third constraint is picking a binned leg length.  We will overdrive the screw to match
		the distance between the bottom of the truss and the top of the screw with a leg length
		we have available.  We subtract depth tolerance from the leg length because the LEG_TOP_TO_TRUSS_CENTER
		is for the absolutely shortest leg that will be crimpable.  Since the tolerance for the
		drive to height is +/- DRIVE_DEPTH_TOLERANCE, we add this in so the leg we want is overlapped
		into the tolerance window by 1/2.
	*)
	IF ((pNVM3^.PRODUCT_INSTALL = eProductType.PRODUCT_ATI) AND (TRUSS_TYPE_LATCH = eTrussType.TRUSS_TYPE_CENTER_STRUCTURE)) THEN
		LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - pNVM3^.ATOL_TO_WP_MOTOR;
	ELSIF isNXTmotorTruss_perScrewParams() THEN
		IF (pNVM3^.PRODUCT_INSTALL = eProductType.PRODUCT_NXT_SI) THEN
			IF (pNVM3^.PRODUCT_INSTALL = eProductType.PRODUCT_NXT_SI) 
				AND
				(SCREW_SIDE_LATCH = eScrewSide.SCREW_CENTER)
				THEN
// 			IF isNXT_SImotorThirdLegLatched() THEN
				IF pNVM4^.TRACKER_ROW_TYPE = eTrackerRow.TRACKER_ROW_SI_STANDARD THEN
					LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - pNVM4^.NXT_TLM_3L_ATOL_TO_WP;
				ELSE
					LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - pNVM4^.NXT_TLM_3L_HEAVY_ATOL_TO_WP;
				END_IF
			ELSE
				LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - pNVM4^.NXT_TLM_T_ATOL_TO_WP;
			END_IF
		ELSE // NXT_INT and NXT_VAR
			IF isNXTmotorThirdLeg_perLatch() THEN
				LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - HMI_REALS_VALUES[NXT2_TLM_3L_ATOL_TO_WP];
			ELSE // side leg
				LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - HMI_REALS_VALUES[NXT2_TLM_T_ATOL_TO_WP];
			END_IF
		END_IF
	ELSE// array trusses
		IF (pNVM3^.PRODUCT_INSTALL = eProductType.PRODUCT_NXT_INT) THEN
			LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - ET2_STD_ATOL_TO_WP;
		ELSE 
			// Most common configuration for array trusses comes here.
			LEG_LENGTH_EMBED := SCREW_REF_FROM_WP_EMBED - pNVM1^.ATOL_TO_WP;
		END_IF
		
	END_IF
	// this does not apply
// 	IF WP_HEIGHT_LATCH = WP_HIGH THEN
// 		LEG_LENGTH_EMBED := LEG_LENGTH_EMBED - HIGH_WP_SIDE_LEG_Z_REDUCTION;
// 	END_IF
	(* Find the next leg length up from the ideal.  We do not specify a maximum overdrive
		depth... if you use a long screw with a small embedment and low workpoint, you'll
		get a lot of overdrive to get to the shortest leg! *)
	FOUND := FALSE;
	FOR INDEX := 1 TO LEG_LENGTHS_COUNT DO
		(* Go from shortest to longest leg, searching for a length greater than
			what we would like. *)
		IF pNVM2^.LEG_LENGTH_USED[INDEX] AND pNVM2^.LEG_LENGTHS_CM[INDEX] > LEG_LENGTH_EMBED THEN
			LEG_LENGTH_ACTUAL := pNVM2^.LEG_LENGTHS_CM[INDEX];
			(* Found a leg, exit the for loop. *)
			FOUND := TRUE;
			LEG_BIN := INDEX;
			EXIT;
		END_IF
	END_FOR;

	IF NOT FOUND THEN
		(* Error, we want a leg length that is longer than what we possess! *)
		//ERROR := TRUE;
		//gotoErrorState(REASON := 'Attempt to use a leg longer that what is available!');
		//RETURN;
		// Longest leg isn't long enough, flag to cut the leg.  Fake the leg bin because the embedment
		//	reduction needs someplace to start.
		LEG_BIN := LEG_LENGTHS_COUNT;
		LEG_LENGTH_ACTUAL := LEG_LENGTH_EMBED;
	END_IF
	
	LEG_OVERDRIVE := (LEG_LENGTH_ACTUAL - LEG_LENGTH_EMBED);
	SCREW_END_POS := CROWD_EMBED_ENDPOINT - LEG_OVERDRIVE + pNVM1^.SCREW_STOP_THRESHOLD;
	IF SCREW_SIDE_LATCH = SCREW_RIGHT THEN
		SCREW_END_POS := SCREW_END_POS + pNVM3^.RIGHT_LEFT_DIFF;
	END_IF

	(* Now if the operator is going to stop the screw drive, this means that there is trouble with the
		drive to depth calculation.  In this case, we want to drive an extra bit beyound where we think we
		need to get, because that will make sure we get to the point where the operator will be satisfied. *)
	IF pNVM3^.MANUAL_DEPTH THEN
		SCREW_END_POS := SCREW_END_POS - SCREW_MANUAL_OVERDRIVE;	
	END_IF
	
	IF NOT FOUND THEN
		// Flag the UI the operator needs to cut a leg.
		LEG_LENGTH_ACTUAL := 0;
	END_IF
	
	(* The problem is over constrained, and we can't satisfy everybody.  We want to always
		hit minimum embedment, and we want to always keep the crowd from crashing.  So we
		limit the lower crowd to a position a couple of centimeters from its estop location,
		which will respect minimum embedment when the ground is flat. *)
	IF SCREW_END_POS < LOWER_CROWD_MIN_END_POS THEN
		(* This will ***require a custom leg length***, because the leg we want to fit is too long
			for the lower crowd to install. *)
		IF ((pNVM3^.PRODUCT_INSTALL = eProductType.PRODUCT_ATI) AND (TRUSS_TYPE_LATCH = eTrussType.TRUSS_TYPE_CENTER_STRUCTURE)) THEN
			// With the ATI center structure, the legs are really short, so we want to open up as much room as
			//	possible for them.
			SCREW_END_POS := LOWER_CROWD_MIN_END_POS + 1;
		ELSE
			// We just drive to embedment, then let the operator cut a leg.
			SCREW_END_POS := SCREW_END_POS + LEG_OVERDRIVE;
		END_IF
		
		IF SCREW_END_POS < LOWER_CROWD_MIN_END_POS THEN
			(* Error, we cannot drive to minimum embedment because of restriction on lower crowd motion! *)
			ERROR := TRUE;
			gotoErrorState(REASON := 'Cannot drive screw to minimum embedment, LC range!');
			RETURN;
		END_IF
		
		(* Flag the user that a leg has to be cut! *)
		LEG_LENGTH_ACTUAL := 0;
	END_IF

	DRIVE_LEG_LENGTH := LEG_LENGTH_ACTUAL;
	DRIVE_SCREW_LENGTH := SCREW_PARAMETERS_CURRENT.SCREW_LENGTH;
	
	DRIVE_MINIMUM_EMBEDMENT := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH;
	DRIVE_TARGET_EMBEDMENT := SCREW_PARAMETERS_CURRENT.EMBED_LENGTH + LEG_OVERDRIVE + DRIVE_DEPTH_TOLERANCE;
	DRIVE_LEG_REVEAL := SCREW_PARAMETERS_CURRENT.SCREW_LENGTH - DRIVE_TARGET_EMBEDMENT;
	
	// debug
	TestVar1 := DRIVE_TARGET_EMBEDMENT;
	
END_IF

DRIVE_DESIRED := SCREW_START_POS - SCREW_END_POS;

// All calculations have been made, report to the web!
CanMonitor.manageCan3_01.bufferScrewDriveStart(DATA8 := 0);


