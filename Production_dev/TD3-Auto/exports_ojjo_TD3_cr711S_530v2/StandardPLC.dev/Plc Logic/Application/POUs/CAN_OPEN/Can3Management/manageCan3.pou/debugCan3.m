
(********************** Declaration ****************************)
METHOD debugCan3
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF LHP_SEND_CYCLE THEN
	LHP_SEND_CYCLE := FALSE;
	bufferCycleTime(STEP := 99, DAT := 0, SCREW := 123456, SIDE := 1, TRUSS := 1, MS := 9999);
END_IF

IF LHP_SEND_SCREW_START THEN
	LHP_SEND_SCREW_START := FALSE;
	bufferScrewDriveStart(DATA8 := 0);
END_IF

IF LHP_SEND_SCREW_DONE THEN
	LHP_SEND_SCREW_DONE := FALSE;
	bufferScrewDriveDone(SUCCESS := 1, DATA8 := 0);
END_IF


