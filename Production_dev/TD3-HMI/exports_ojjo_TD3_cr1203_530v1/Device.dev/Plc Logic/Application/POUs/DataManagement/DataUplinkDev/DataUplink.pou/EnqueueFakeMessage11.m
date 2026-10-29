
(********************** Declaration ****************************)
METHOD EnqueueFakeMessage11 : BOOL
VAR_INPUT
    DRIVE_TIME : REAL;
END_VAR
VAR
    sLocalScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
sLocalScrewId := TO_STRING(RECEIVE_1.SCREW_NUMBER_TRANSMIT);

IF NOT StartPayload(uiMessageId := 11, sPreScrewId := sLocalScrewId) THEN
    EnqueueFakeMessage11 := FALSE;
    RETURN;
END_IF

AddNumberTextField(sName := 'DriveTime', sValue := floatTrim(DRIVE_TIME, 2));
AddNumberTextField(sName := 'LowerCrowdDelta', sValue := floatTrim(RECEIVE_3.DRIVE_LOWER_CROWD_DELTA, 2));
AddNumberTextField(sName := 'LowerRotaryDelta', sValue := floatTrim(RECEIVE_3.DRIVE_LOWER_ROTARY_DELTA, 3));
AddNumberTextField(sName := 'CurrentEmbedment', sValue := floatTrim(RECEIVE_3.DRIVE_CURRENT_EMBEDMENT, 2));
AddNumberTextField(sName := 'LowerCrowdPressure', sValue := floatTrim(RECEIVE_3.LOWER_CROWD_PRESSURE_FILTERED, 1));
AddNumberTextField(sName := 'LowerRotaryPressure', sValue := floatTrim(RECEIVE_3.LOWER_ROTARY_PRESSURE_FILTERED, 1));
AddNumberTextField(sName := 'UpperCrowdPressure', sValue := floatTrim(RECEIVE_3.UPPER_CROWD_PRESSURE_FILTERED, 1));
AddNumberTextField(sName := 'UpperRotaryPressure', sValue := floatTrim(RECEIVE_3.UPPER_ROTARY_PRESSURE_FILTERED, 1));
AddNumberTextField(sName := 'PumpPressure', sValue := floatTrim(RECEIVE_3.PUMP_PRESSURE, 1));
AddNumberTextField(sName := 'NoPurpose0', sValue := '0');
AddNumberTextField(sName := 'EStop', sValue := TO_STRING(RECEIVE_1.ESTOP_CURRENT));
AddNumberTextField(sName := 'Warning', sValue := TO_STRING(RECEIVE_1.WARNING_CURRENT));
AddNumberTextField(sName := 'FeedbackFail', sValue := TO_STRING(RECEIVE_1.FEEDBACK_FAIL_CURRENT));
AddNumberTextField(sName := 'ValveFail', sValue := TO_STRING(RECEIVE_1.VALVE_FAIL_CURRENT));
AddNumberTextField(sName := 'DriveBitReveal', sValue := floatTrim(RECEIVE_3.DRIVE_BIT_REVEAL, 2));
AddNumberTextField(sName := 'LowerCrowdVelocity', sValue := floatTrim(RECEIVE_1.LOWER_CROWD_VELOCITY_TRANSMIT, 2));
AddNumberTextField(sName := 'LowerCrowdOutput', sValue := floatTrim(RECEIVE_1.LOWER_CROWD_OUTPUT, 1));
AddNumberTextField(sName := 'LowerRotaryVelocity', sValue := floatTrim(RECEIVE_1.LOWER_ROTARY_VELOCITY_TRANSMIT, 2));
AddNumberTextField(sName := 'LowerRotaryOutput', sValue := floatTrim(RECEIVE_1.LOWER_ROTARY_OUTPUT, 1));
AddNumberTextField(sName := 'LowerCrowdVelocitySetpoint', sValue := floatTrim(RECEIVE_3.LOWER_CROWD_VELOCITY_SETPOINT_TRANSMIT, 2));
AddNumberTextField(sName := 'LowerRotaryVelocitySetpoint', sValue := floatTrim(RECEIVE_3.LOWER_ROTARY_VELOCITY_SETPOINT_TRANSMIT, 3));
AddNumberTextField(sName := 'LowerCrowdValvePosition', sValue := TO_STRING(RECEIVE_3.LOWER_CROWD_VALVE_POSITION));
AddNumberTextField(sName := 'LowerRotaryValvePosition', sValue := TO_STRING(RECEIVE_3.LOWER_ROTARY_VALVE_POSITION));
AddNumberTextField(sName := 'DrifterAirOpen', sValue := TO_STRING(RECEIVE_1.DRIFTER_AIR_OPEN_ACTUAL));
AddBoolField(sName := 'CompressorTurnedOn', xValue := RECEIVE_1.COMPRESSOR_TURNED_ON);
AddNumberTextField(sName := 'HammerCommand', sValue := TO_STRING(RECEIVE_1.HAMMER_CMD));
AddNumberTextField(sName := 'ScrewState', sValue := TO_STRING(RECEIVE_1.SCREW_STATE_TRANSMIT));
AddNumberTextField(sName := 'HammerDistance', sValue := floatTrim(RECEIVE_3.HAMMER_DISTANCE, 2));
AddNumberTextField(sName := 'WaterFlow', sValue := floatTrim(RECEIVE_3.WATER_FLOW_LPM, 3));
AddNumberTextField(sName := 'WaterVolume', sValue := floatTrim(RECEIVE_3.WATER_VOLUME_L, 2));
AddNumberTextField(sName := 'SoftSoilDetected', sValue := TO_STRING(RECEIVE_2.SS_DETECTED));
AddBoolField(sName := 'HardSoilDetected', xValue := RECEIVE_2.HARD_SOIL_DETECTED);
AddNumberTextField(sName := 'DrillSetupSoftSoil', sValue := TO_STRING(RECEIVE_3.DRILL_SETUP_SOFT_SOIL));
AddNumberTextField(sName := 'LowerCrowdStallCount', sValue := TO_STRING(RECEIVE_3.LC_STALL_COUNT));
AddNumberTextField(sName := 'LowerCrowdRevealStallCount', sValue := TO_STRING(RECEIVE_3.LC_REVEAL_STALL_COUNT));

EnqueueFakeMessage11 := FinishPayload(uiMessageId := 11, uiPriority := 2);