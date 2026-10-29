
(********************** Declaration ****************************)
METHOD isDoneDriveStates : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
isDoneDriveStates := SCREW_STATE_TRANSMIT = SCREW_STATE_RETRACT_AFTER_DRIVE OR
	SCREW_STATE_TRANSMIT = SCREW_STATE_UNLOAD_SCREW;
