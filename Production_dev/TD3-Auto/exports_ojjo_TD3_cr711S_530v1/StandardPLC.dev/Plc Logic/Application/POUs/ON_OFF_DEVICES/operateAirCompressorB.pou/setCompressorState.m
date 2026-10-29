
(********************** Declaration ****************************)
METHOD setCompressorState : BOOL
VAR_INPUT
	NEW_STATE: eAirCompressorStates;
END_VAR

(********************** Implementation ****************************)
IF NEW_STATE = COMPRESSOR_STATE THEN
	// Should not call change state when none is necessary.
	gotoErrorState(REASON := CONCAT('Air compressor control logic flawed!', TO_STRING(NEW_STATE)));
END_IF

// Entry function for new state here.
CASE NEW_STATE OF
	COMPRESSOR_OFF:
		BLOWDOWN_START_TIME := TIME_SECONDS;
	COMPRESSOR_WARMUP:
		WARMUP_START_TIME := TIME_SECONDS;
	COMPRESSOR_RUN_LOADED:
		;
	COMPRESSOR_SHUTDOWN:
		SHUTDOWN_START_TIME := TIME_SECONDS;
END_CASE

// Update actual state.
COMPRESSOR_STATE := NEW_STATE;
