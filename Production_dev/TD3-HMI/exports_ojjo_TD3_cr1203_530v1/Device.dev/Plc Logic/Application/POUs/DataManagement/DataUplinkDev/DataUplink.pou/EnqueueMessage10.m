
(********************** Declaration ****************************)
METHOD EnqueueMessage10 : BOOL
VAR
    sLocalScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
sLocalScrewId := TO_STRING(RECEIVE_1.SCREW_NUMBER_TRANSMIT);

IF NOT StartPayload(uiMessageId := 10, sPreScrewId := sLocalScrewId) THEN
    EnqueueMessage10 := FALSE;
    RETURN;
END_IF

AddNumberTextField(sName := 'ScrewLength', sValue := TO_STRING(RECEIVE_1.DRIVE_SCREW_LENGTH));
AddNumberTextField(sName := 'LegLength', sValue := TO_STRING(RECEIVE_1.DRIVE_LEG_LENGTH));
AddNumberTextField(sName := 'MinimumEmbedment', sValue := TO_STRING(RECEIVE_1.DRIVE_MINIMUM_EMBEDMENT));
AddNumberTextField(sName := 'TargetEmbedment', sValue := TO_STRING(RECEIVE_1.DRIVE_TARGET_EMBEDMENT));
AddNumberTextField(sName := 'WorkPointHeight', sValue := TO_STRING(RECEIVE_1.DRIVE_WP_HEIGHT));
AddNumberTextField(sName := 'LowerCrowdPosition', sValue := TO_STRING(RECEIVE_1.LOWER_CROWD_POSITION));
AddNumberTextField(sName := 'LowerRotaryAngle', sValue := TO_STRING(RECEIVE_1.LOWER_ROTARY_ANGLE));
AddNumberTextField(sName := 'K_vff', sValue := TO_STRING(RECEIVE_2.DRIVE_KVFF_VALUE));
AddNumberTextField(sName := 'K_p', sValue := TO_STRING(RECEIVE_2.DRIVE_KP_VALUE));
AddNumberTextField(sName := 'K_i', sValue := TO_STRING(RECEIVE_2.DRIVE_KI_VALUE));
AddNumberTextField(sName := 'I_limit', sValue := TO_STRING(RECEIVE_2.DRIVE_ILIMIT_VALUE));
AddNumberTextField(sName := 'OutputMaxValue', sValue := TO_STRING(RECEIVE_2.DRIVE_OUTPUT_MAX_VALUE));
AddNumberTextField(sName := 'LowerCrowdDriveVelHigh', sValue := TO_STRING(RECEIVE_2.LC_DRIVE_VEL_HI_VALUE));
AddNumberTextField(sName := 'UpperRotaryDrivePressureLow', sValue := TO_STRING(RECEIVE_2.UR_DRIVE_PRESSURE_LOW_VALUE));
AddNumberTextField(sName := 'LowerCrowdDriveVelLow', sValue := TO_STRING(RECEIVE_2.LC_DRIVE_VEL_LOW_VALUE));
AddNumberTextField(sName := 'UpperRotaryDrivePressureHigh', sValue := TO_STRING(RECEIVE_2.UR_DRIVE_PRESSURE_HI_VALUE));
AddNumberTextField(sName := 'BasePitch', sValue := TO_STRING(RECEIVE_1.BASE_PITCH_TRANSMIT));
AddNumberTextField(sName := 'BaseRoll', sValue := TO_STRING(RECEIVE_1.BASE_ROLL_TRANSMIT));
AddNumberTextField(sName := 'RotatorAngle', sValue := TO_STRING(RECEIVE_1.ROTATOR_ANGLE));
AddNumberTextField(sName := 'Value361', sValue := '361');
AddNumberTextField(sName := 'HydraulicTemperature', sValue := TO_STRING(RECEIVE_1.HYDRAULIC_TEMP));
AddNumberTextField(sName := 'TorqueTubePitchValue', sValue := TO_STRING(TORQUE_TUBE_PITCH_VALUE));
AddNumberTextField(sName := 'FuelLevel', sValue := TO_STRING(FUEL_LEVEL));
AddNumberTextField(sName := 'ScrewStopThresholdValue', sValue := TO_STRING(SCREW_STOP_THRESHOLD_VALUE));
AddNumberTextField(sName := 'PLCBoardTemperature', sValue := TO_STRING(PLC_BOARD_TEMP));
AddNumberTextField(sName := 'PLCChipTemperature', sValue := TO_STRING(PLC_CHIP_TEMP));
AddNumberTextField(sName := 'HMIBoardTemperature', sValue := TO_STRING(Temperatures.rBoard));
AddNumberTextField(sName := 'HMIChipTemperature', sValue := TO_STRING(Temperatures.rCore0));
AddNumberTextField(sName := 'VBB15_MV', sValue := TO_STRING(VBB15_MV));
AddNumberTextField(sName := 'VBB30_MV', sValue := TO_STRING(VBB30_MV));
AddNumberTextField(sName := 'TrackerRowType', sValue := TO_STRING(TRACKER_ROW_TYPE_VALUE));
AddNumberTextField(sName := 'AirCompressorTemperature', sValue := TO_STRING(AIR_COMPRESSOR_TEMP));
AddNumberTextField(sName := 'AirCompressorWetPressure', sValue := TO_STRING(AIR_COMPRESSOR_WET_PRESSURE));

EnqueueMessage10 := FinishPayload(uiMessageId := 10, uiPriority := 1);