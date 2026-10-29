
(********************** Declaration ****************************)
METHOD ScrewStateLoadScrew : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF CYCLE_STEP <> eCycleSteps.CYCLE_STEP_LOAD_SCREW THEN
	setCycletimeData(eCycleSteps.CYCLE_STEP_LOAD_SCREW, 0, 0, -1, TRUSS_TYPE_LATCH);
	// 
	PROXIMITY_SENSOR_PRESENCE_CONFIRMED := FALSE;
END_IF
machineState_01.checkProximitySensorStatus();
// Always waiting on the operator in this state.	
IF 	PROXIMITY_SENSOR_PRESENCE_CONFIRMED THEN
	setWaitingStrings('Operator', 'Operator');
ELSE
	setWaitingStrings('Proximity tag req', 'Proximity tag');
END_IF


confirmMonitorStart();
IF (confirmRequested() OR CONFIRM_EARLY) AND PROXIMITY_SENSOR_PRESENCE_CONFIRMED THEN
	SCREW_SIDE_LATCH := getScrewSide();

	IF NOT isStartAllowed() THEN
		// Message was put up by the "allowed" function, just honk the horn here.
		hornRequest(3, T#500MS, T#100MS); 
	ELSE
		(* If the machine is setup for soft soil operation, assume the soil is soft when starting and
		wait for evidence to get less aggressive!  If the machine is not setup for soft soil,
		just assume it is hard from the get-go. *)
		IF pNVM4^.SOFT_SOIL_ENABLED THEN
			HARD_SOIL_DETECTED := FALSE;
			DRILL_SETUP_SOFT_SOIL := 1;
		ELSE
			// When SS is *not* enabled, we still need to set these values!  Some logic in this state machine
			//	works differently depending on these state variables.
			HARD_SOIL_DETECTED := TRUE;
			DRILL_SETUP_SOFT_SOIL := 0;
		END_IF
		
		(* Reset soft soil redrill count. *)
		LC_STALL_COUNT := 0;
		LC_REVEAL_STALL_COUNT := 0;
		
		(* We are starting a new screw drive. *)
		RETURNING_TO_DRIVE := FALSE;

		(* Calculate any required setpoints for low workpoints. *)
		lowWpSetpoints();

		setScrewModeState(SCREW_STATE_MAST_TO_TARGET);
		ROTATOR_MONITOR(INIT := TRUE);
		setCycletimeData(eCycleSteps.CYCLE_STEP_MAST_TO_TARGET, 0, 0, SCREW_SIDE_LATCH, TRUSS_TYPE_LATCH);
	END_IF
ELSE
	(* We can optionally go out to assemble mode. *)
	f2MonitorStart();
	IF f2Requested() THEN
		setScrewModeState(SCREW_STATE_CLEAR_TRUSS_CAP);
		FIRST_IN_LEVEL := TRUE;
	END_IF
END_IF