
(********************** Declaration ****************************)
METHOD parseGeneralSettings : bool
VAR_INPUT
	secondPass : BOOL;
END_VAR
VAR
	JSON_ELEMENT_LOCAL : JSON.JSONElement;
	xFound : BOOL;

END_VAR

(********************** Implementation ****************************)
parseGeneralSettings := TRUE;

(* ----- get settings format version ----- *)
IF NOT parseStringSetting(
    wsKey := "General Config Ver",
    secondPass := secondPass,
    xRequired := TRUE,
    uiMaximumLength := 20,
    uiDestinationCapacity :=
        SIZEOF(
            TRANSMIT_2.SET_HMI_STRINGS[GENERAL_SETTINGS_CONFIG_VERSION]
        ),
    pDestination :=
        ADR(
            TRANSMIT_2.SET_HMI_STRINGS[GENERAL_SETTINGS_CONFIG_VERSION]
        )
) THEN

    parseGeneralSettings := FALSE;
    RETURN;
END_IF;

// (* ----- get format version ----- *)
// IF NOT parseStringSetting20(
// 	wsKey := "General Config Ver",
// 	secondPass := secondPass,
// 	xRequired := TRUE,
// 	uiMaximumLength := 20,
// 	pDestination := ADR(
// 		TRANSMIT_2.SET_HMI_STRINGS[GENERAL_SETTINGS_CONFIG_VERSION]
// 	)
// ) THEN
// 	parseGeneralSettings := FALSE;
// 	RETURN;
// END_IF;

// Outrigger enabled
IF NOT parseBoolSetting(
	wsKey := "outrigger enabled",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_OUTRIGGER_ENABLED_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// TCH speeds
IF NOT parseUIntSetting(
	wsKey := "TCH down speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_TCH_DOWN_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "TCH up speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_TCH_UP_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Centralizer speeds
IF NOT parseUIntSetting(
	wsKey := "centralizer open speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_CENTRALIZER_OPEN_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "centralizer close speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_CENTRALIZER_CLOSE_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Crimper speeds
IF NOT parseUIntSetting(
	wsKey := "left crimper open speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_CRIMPER_LEFT_OPEN_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "left crimper close speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_CRIMPER_LEFT_CLOSE_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "right crimper open speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_CRIMPER_RIGHT_OPEN_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "right crimper close speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_CRIMPER_RIGHT_CLOSE_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Upper rotary speeds
IF NOT parseUIntSetting(
	wsKey := "upper rotary forward speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_UPPER_ROTARY_FWD_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "upper rotary reverse speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_UPPER_ROTARY_REV_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Blade speeds
IF NOT parseUIntSetting(
	wsKey := "blade up speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_BLADE_UP_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseUIntSetting(
	wsKey := "blade down speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.HMI_BLADE_DOWN_SPEED
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Preload
IF NOT parseRealSetting(
	wsKey := "preload speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 200.0,
	pDestination := ADR(
		TRANSMIT_1.SET_PRELOAD_SPEED_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Maximum roll and pitch limits
IF NOT parseRealSetting(
	wsKey := "max roll start",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAX_ROLL_START_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "max pitch forward start",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAX_PITCH_FWD_START_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "max pitch backward start",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAX_PITCH_BACK_START_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "max roll continue",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAX_ROLL_CONTINUE_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "max pitch forward continue",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAX_PITCH_FWD_CONTINUE_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "max pitch backward continue",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAX_PITCH_BACK_CONTINUE_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "max boom swing start",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 27.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAX_BS_START_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

(* GPS settings *)
// GPS autotarget selection
IF NOT parseUIntSetting(
	wsKey := "GPS autotarget selection",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 65535.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AUTOTARGET_SELECTION
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// GPS axis settings
IF NOT parseRealSetting(
	wsKey := "GPS heading in range",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 22.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[1, 7]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS heading on target",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.01,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[1, 8]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS X in range",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[2, 7]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS X on target",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.1,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[2, 8]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS Y in range",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 22.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[3, 7]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS Y on target",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.1,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[3, 8]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS Z in range",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 82.5,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[4, 7]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS Z on target",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.1,
	lrMaximum := 50.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_AXES_SETTINGS[4, 8]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// GPS general settings
IF NOT parseRealSetting(
	wsKey := "GPS velocity factor",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.05,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[1]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS acceleration factor",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.01,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[2]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS radio signal delay warning",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 8.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[3]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS radio signal delay critical",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 2.0,
	lrMaximum := 9.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[4]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS transition to crimp factor",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 9.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[5]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS transition to feedback autotarget factor",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 9.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[6]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS tracking X adjust",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1000.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[13]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "GPS tracking Z adjust",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1000.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_GPS_GENERAL_SETTINGS[14]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Packed HMI boolean settings
IF NOT parseBoolSetting(
	wsKey := "FWP Z autotarget",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[FWP_Z_AUTOTARGET]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseBoolSetting(
	wsKey := "high WP allowed",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[HIGH_WP_ALLOWED]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseBoolSetting(
	wsKey := "TA auto mode advance",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[TA_AUTO_MODE_ADVANCE]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Packed HMI real settings
IF NOT parseSintSetting(
	wsKey := "screw drive manual auto delay",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1,
	lrMaximum := 600,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[SCREW_DRIVE_MAN_AUTO_DELAY]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "TA pitch reduction angle",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 15.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[TA_PITCH_REDUCTION_ANGLE]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "TA roll reduction angle",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 15.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[TA_ROLL_REDUCTION_ANGLE]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "TA max speed",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[TA_MAX_SPEED]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "TA correction aggression",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.05,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[TA_CORRECTION_AGGRESSION]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "LC stall hammer time",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1.0,
	lrMaximum := 5.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[LC_STALL_HAMMER_TIME]
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;


// Chuck to bushing
IF NOT parseRealSetting(
	wsKey := "chuck to bushing",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_1.SET_CHUCK_TO_BUSHING_VALUE
	)
) THEN
	parseGeneralSettings := FALSE;
	RETURN;
END_IF;