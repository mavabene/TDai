
(********************** Declaration ****************************)
METHOD screwDriveExit
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
(* Done, we have driven to depth, or whatever other constraint is active. *)
DRIVE_DEPTH_ERROR_IMMEDIATE := SCREW_END_POS - pLOWER_CROWD^.FEEDBACK.POSITION_ENGR;
BASE_PITCH_END := BASE_ROLL_FILTERED_FAST;
KNUCKLE_PITCH_END := AXES[AXIS_PITCH].FEEDBACK.POSITION_ENGR;
MANDREL_PITCH_ERROR := TAN_DEG(BASE_PITCH_END - BASE_PITCH_START) * BASE_PITCH_PIVOT_LEN;
SCREW_DRIVE_DONE := TRUE;
DRIVE_VEL_SETPOINT := 0;
DRIVE_PWM_OUTPUT := 0;

// Count legs and screws used to help supply chain.
pNVM4^.LEG_LENGTH_COUNT[LEG_BIN] := pNVM4^.LEG_LENGTH_COUNT[LEG_BIN] + 1;
pNVM4^.SCREW_LENGTH_COUNT[SCREW_LENGTH_LATCH] := pNVM4^.SCREW_LENGTH_COUNT[SCREW_LENGTH_LATCH] + 1;
setOutput(ADR(pLOWER_CROWD^.OUTPUT), 0, FALSE);

// All calculations have been made, report to the web!
CanMonitor.manageCan3_01.bufferScrewDriveDone(SUCCESS := 1, DATA8 := 0);
