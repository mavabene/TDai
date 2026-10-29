
(********************** Declaration ****************************)
METHOD parseMachineSpecificSettings : bool
VAR_INPUT
	secondPass : BOOL;
END_VAR

VAR
	JSON_ELEMENT_LOCAL : JSON.JSONElement;
	xFound : BOOL;
END_VAR
(********************** Implementation ****************************)
parseMachineSpecificSettings := TRUE;


// Machine serial — required and must match this PLC
IF NOT validateJsonValue(
	wsKey := "Machine Serial",
	eKind := eJsonConfigValueKind.eJSON_CFG_INTEGER,
	xRequired := TRUE,
	xUseLimits := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 9999.0,
	jsonElement => JSON_ELEMENT_LOCAL,
	xFound => xFound
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF JSON_ELEMENT_LOCAL.value.liValue <>
	NVM.MACHINE_SERIAL_NUMBER_FROM_PLC THEN

	parseMachineSpecificSettings := FALSE;
	Data_Handling.CONFIG_STATUS_MSG := 'Machine number mismatch';
	RETURN;
END_IF;

IF secondPass THEN
	TRANSMIT_1.SET_MACHINE_SERIAL_VALUE :=
		TO_INT(JSON_ELEMENT_LOCAL.value.liValue);
END_IF;

(* ----- get settings format version ----- *)
IF NOT parseStringSetting(
    wsKey := "TD Config Version",
    secondPass := secondPass,
    xRequired := TRUE,
    uiMaximumLength := 20,
    uiDestinationCapacity :=
        SIZEOF(
            TRANSMIT_2.SET_HMI_STRINGS[TD_SPECIFIC_SETTINGS_CONFIG_VERSION]
        ),
    pDestination :=
        ADR(
            TRANSMIT_2.SET_HMI_STRINGS[TD_SPECIFIC_SETTINGS_CONFIG_VERSION]
        )
) THEN

    parseMachineSpecificSettings := FALSE;
    RETURN;
END_IF;

// (* ----- get format version ----- *)
// IF NOT parseStringSetting20(
// 	wsKey := "TD Config Version",
// 	secondPass := secondPass,
// 	xRequired := TRUE,
// 	uiMaximumLength := 20,
// 	pDestination := ADR(
// 		TRANSMIT_2.SET_HMI_STRINGS[TD_SPECIFIC_SETTINGS_CONFIG_VERSION]
// 	)
// ) THEN
// 	parseMachineSpecificSettings := FALSE;
// 	RETURN;
// END_IF;

// Encoder calibration values
IF NOT parseUDINTSetting(
	wsKey := "z slide encoder zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(
		TRANSMIT_2.SET_Z_SLIDE_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "x slide encoder zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(
		SET_X_SLIDE_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "mast slide encoder at ref",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAST_SLIDE_ENCODER_AT_REF
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "mast slide encoder at zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAST_SLIDE_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "yaw encoder at zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 16384.0,
	pDestination := ADR(
		SET_YAW_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "lower crowd encoder at ref",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 33554432.0,
	pDestination := ADR(
		SET_LOWER_CROWD_ENCODER_AT_REF
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "lower crowd encoder at zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 33554432.0,
	pDestination := ADR(
		SET_LOWER_CROWD_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "lower crowd mast to slide offset",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		SET_LOWER_CROWD_MAST_TO_SLIDE_OFFSET
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "upper crowd encoder at zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 16777216.0,
	pDestination := ADR(
		SET_UPPER_CROWD_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "boom swing encoder at zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 16384.0,
	pDestination := ADR(
		SET_BOOM_SWING_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "lower crowd COR position",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 67108864.0,
	pDestination := ADR(
		TRANSMIT_1.SET_LOWER_CROWD_COR_POS_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Machine type and hardware
IF NOT parseUDINTSetting(
	wsKey := "machine version",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 19.0,
	pDestination := ADR(
		TRANSMIT_1.SET_MACHINE_VERSION_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "boom lift encoder at zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 16384.0,
	pDestination := ADR(
		TRANSMIT_2.SET_BOOM_LIFT_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "joint lift encoder at zero",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 16384.0,
	pDestination := ADR(
		TRANSMIT_2.SET_JOINT_LIFT_ENCODER_AT_ZERO
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "LR encoder resolution",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1000.0,
	lrMaximum := 8192.0,
	pDestination := ADR(
		SET_LR_ENCODER_RES_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseIntSetting(
	wsKey := "lower crowd encoder type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_LOWER_CROWD_ENCODER_TYPE_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "hammer speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_HAMMER_SPEED
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "air compressor type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_1.SET_MACHINE_COMPRESSOR_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "drifter type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_1.SET_MACHINE_DRIFTER_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "lower rotary type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_1.SET_MACHINE_LR_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "GPS vendor",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 3.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_VENDOR
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Encoder types
IF NOT parseSIntSetting(
	wsKey := "boom lift encoder type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[BOOM_LIFT_ENCODER_TYPE]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseSIntSetting(
	wsKey := "boom swing encoder type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[BOOM_SWING_ENCODER_TYPE]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseSIntSetting(
	wsKey := "joint lift encoder type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[JOINT_LIFT_ENCODER_TYPE]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseSIntSetting(
	wsKey := "upper crowd encoder type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[UPPER_CROWD_ENCODER_TYPE]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseSIntSetting(
	wsKey := "yaw encoder type",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[YAW_ENCODER_TYPE]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Other machine values
IF NOT parseRealSetting(
	wsKey := "knuckle to mast pitch delta",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -10.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[KNUCKLE_TO_MAST_PITCH_DELTA]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "screw number",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(
		SET_SCREW_NUMBER
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// PLC temperatures and supply voltages
IF NOT parseIntSetting(
	wsKey := "PLC board temperature max",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 400.0,
	pDestination := ADR(
		SET_PLC_BOARD_TEMP_MAX
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseIntSetting(
	wsKey := "PLC chip temperature max",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 400.0,
	pDestination := ADR(
		SET_PLC_CHIP_TEMP_MAX
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseIntSetting(
	wsKey := "PLC board temperature min",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -100.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_2.SET_PLC_BOARD_TEMP_MIN
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseIntSetting(
	wsKey := "PLC chip temperature min",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -100.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_2.SET_PLC_CHIP_TEMP_MIN
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "VBB15 millivolts max",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 65000.0,
	pDestination := ADR(
		SET_VBB15_MV_MAX
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "VBB30 millivolts max",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 65000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_VBB30_MV_MAX
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "VBB15 millivolts min",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 65000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_VBB15_MV_MIN
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "VBB30 millivolts min",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 65000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_VBB30_MV_MIN
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Operating settings
IF NOT parseBoolSetting(
	wsKey := "load unload",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_LOAD_UNLOAD_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "air compressor temp max",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -999.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		SET_AIR_COMPRESSOR_TEMP_MAX
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "air compressor pressure max",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -999.0,
	lrMaximum := 250.0,
	pDestination := ADR(
		TRANSMIT_2.SET_AIR_COMPRESSOR_PRESSURE_MAX
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "upper crowd drill steel",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_1.SET_UPPER_CROWD_DRILL_STEEL_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "right left difference",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -20.0,
	lrMaximum := 20.0,
	pDestination := ADR(
		TRANSMIT_2.SET_RIGHT_LEFT_DIFF_VALUE
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Optional leg-length counts
IF NOT parseUDINTSetting(
	wsKey := "leg length count 1",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[1])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 2",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[2])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 3",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[3])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 4",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[4])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 5",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[5])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 6",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[6])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 7",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[7])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 8",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[8])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 9",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[9])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "leg length count 10",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(SET_LEG_LENGTH_COUNT[10])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Optional screw-length counts
IF NOT parseUDINTSetting(
	wsKey := "screw length count 1",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(TRANSMIT_2.SET_SCREW_LENGTH_COUNT[1])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "screw length count 2",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(TRANSMIT_2.SET_SCREW_LENGTH_COUNT[2])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUDINTSetting(
	wsKey := "screw length count 3",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := 0.0,
	lrMaximum := 4294967295.0,
	pDestination := ADR(TRANSMIT_2.SET_SCREW_LENGTH_COUNT[3])
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Optional GPS antenna offsets
IF NOT parseRealSetting(
	wsKey := "GPS TD specific yaw offset",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := -180.0,
	lrMaximum := 8888.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[7]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS TD specific X offset",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := -1000.0,
	lrMaximum := 8888.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[8]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS TD specific Y offset",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := -1000.0,
	lrMaximum := 8888.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[9]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS TD specific Z offset",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := -1000.0,
	lrMaximum := 8888.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[10]
	)
) THEN
	parseMachineSpecificSettings := FALSE;
	RETURN;
END_IF;


// Login bypass is intentionally not parsed.
// It is always forced OFF in the field.
IF secondPass THEN
	SET_LOGIN_BYPASS_VALUE := FALSE;
END_IF;