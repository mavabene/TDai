
(********************** Declaration ****************************)
METHOD EnqueueMessage20 : BOOL
VAR
    sLocalScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
sLocalScrewId := TO_STRING(RECEIVE_1.SCREW_NUMBER_TRANSMIT);

IF NOT StartPayload(uiMessageId := 20, sPreScrewId := sLocalScrewId) THEN
    EnqueueMessage20 := FALSE;
    RETURN;
END_IF

AddNumberTextField(sName := 'ScrewPitch', sValue := TO_STRING(RECEIVE_3.SCREW_PITCH_VALUE));
AddBoolField(sName := 'UpperRotaryStallEnabled', xValue := RECEIVE_2.UR_STALL_ENABLED_VALUE);
AddBoolField(sName := 'HammerEnabled', xValue := RECEIVE_2.HAMMER_ENABLED_VALUE);
AddBoolField(sName := 'CompressorTurnedOn', xValue := RECEIVE_1.COMPRESSOR_TURNED_ON);
AddBoolField(sName := 'AirFlowReduced', xValue := RECEIVE_2.AIR_FLOW_REDUCED_VALUE);
AddNumberTextField(sName := 'SetDrillBitLength', sValue := TO_STRING(TRANSMIT_1.SET_DRILL_BIT_LENGTH_VALUE));
AddNumberTextField(sName := 'SetDrillBitWingPosition', sValue := TO_STRING(TRANSMIT_1.SET_DRILL_BIT_WING_POSITION_VALUE));
AddNumberTextField(sName := 'SetDrillBitThreadLength', sValue := TO_STRING(TRANSMIT_1.SET_DRILL_BIT_THREAD_LENGTH_VALUE));
AddNumberTextField(sName := 'SetUpperCrowdEndRetractHardValue', sValue := TO_STRING(TRANSMIT_2.SET_UC_END_RETRACT_HARD_VALUE));
AddNumberTextField(sName := 'SetDrillBitDriveProtrusionValue', sValue := TO_STRING(TRANSMIT_1.SET_DRILL_BIT_DRIVE_PROTRUSION_VALUE));
AddNumberTextField(sName := 'ScrewSide', sValue := TO_STRING(TO_INT(RECEIVE_1.SCREW_SIDE_LATCH)));
AddNumberTextField(sName := 'TrussType', sValue := TO_STRING(TO_INT(RECEIVE_2.TRUSS_TYPE_LATCH)));
AddNumberTextField(sName := 'HMIUpperDriveRotaryForwardSpeed', sValue := TO_STRING(HMI_UPPER_ROTARY_FWD_SPEED));
AddNumberTextField(sName := 'HMIUpperDriveRotaryReverseSpeed', sValue := TO_STRING(HMI_UPPER_ROTARY_REV_SPEED));
AddNumberTextField(sName := 'SetLowerDriveCrowdVelocityHighValue', sValue := TO_STRING(TRANSMIT_2.SET_LC_DRIVE_VEL_HI_VALUE));
AddNumberTextField(sName := 'SetLowerDriveCrowdVelocityLowValue', sValue := TO_STRING(TRANSMIT_2.SET_LC_DRIVE_VEL_LOW_VALUE));
AddNumberTextField(sName := 'SetUpperRotaryDrivePressureLowValue', sValue := TO_STRING(TRANSMIT_2.SET_UR_DRIVE_PRESSURE_LOW_VALUE));
AddNumberTextField(sName := 'SetUpperRotaryDrivePressureHighValue', sValue := TO_STRING(TRANSMIT_2.SET_UR_DRIVE_PRESSURE_HI_VALUE));
AddBoolField(sName := 'SetSoftSoilEnabled', xValue := TRANSMIT_1.SET_SOFT_SOIL_ENABLED_VALUE);
AddNumberTextField(sName := 'SetSoftSoilDriveVelocityHighValue', sValue := TO_STRING(TRANSMIT_2.SET_SS_DRIVE_VEL_HI_VALUE));
AddNumberTextField(sName := 'SetSoftSoilDriveVelocityLowValue', sValue := TO_STRING(TRANSMIT_2.SET_SS_DRIVE_VEL_LOW_VALUE));
AddNumberTextField(sName := 'SetLowerCrowdDrivePressureLowValue', sValue := TO_STRING(TRANSMIT_2.SET_LC_DRIVE_PRESSURE_LOW_VALUE));
AddNumberTextField(sName := 'SetLowerCrowdDrivePressureHighValue', sValue := TO_STRING(TRANSMIT_2.SET_LC_DRIVE_PRESSURE_HI_VALUE));
AddNumberTextField(sName := 'SetUpperCrowdEndRetractHardValueDuplicate', sValue := TO_STRING(TRANSMIT_2.SET_UC_END_RETRACT_HARD_VALUE));

EnqueueMessage20 := FinishPayload(uiMessageId := 20, uiPriority := 1);