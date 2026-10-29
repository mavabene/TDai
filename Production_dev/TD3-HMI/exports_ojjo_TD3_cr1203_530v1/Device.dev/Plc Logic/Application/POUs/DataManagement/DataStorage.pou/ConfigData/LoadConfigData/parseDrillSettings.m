
(********************** Declaration ****************************)
METHOD parseDrillSettings : bool
VAR_INPUT
	secondPass : BOOL;
END_VAR
VAR
	
END_VAR
(********************** Implementation ****************************)
parseDrillSettings := TRUE;

(* ----- get settings format version ----- *)
IF NOT parseStringSetting(
    wsKey := "Drill Config Version",
    secondPass := secondPass,
    xRequired := TRUE,
    uiMaximumLength := 20,
    uiDestinationCapacity :=
        SIZEOF(
            TRANSMIT_2.SET_HMI_STRINGS[DRILL_SETTINGS_CONFIG_VERSION]
        ),
    pDestination :=
        ADR(
            TRANSMIT_2.SET_HMI_STRINGS[DRILL_SETTINGS_CONFIG_VERSION]
        )
) THEN

    parseDrillSettings := FALSE;
    RETURN;
END_IF;

// IF NOT parseStringSetting20(
// 	wsKey := "Drill Config Version",
// 	secondPass := secondPass,
// 	xRequired := TRUE,
// 	uiMaximumLength := 20,
// 	pDestination := ADR(
// 		TRANSMIT_2.SET_HMI_STRINGS[DRILL_SETTINGS_CONFIG_VERSION]
// 	)
// ) THEN
// 	parseDrillSettings := FALSE;
// 	RETURN;
// END_IF;
		
(*  ----- get drill settings ----- *)
IF NOT parseRealSetting(
	wsKey := "drill bit length (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 50.0,
	pDestination := ADR(
		TRANSMIT_1.SET_DRILL_BIT_LENGTH_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "drill bit thread length (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 15.0,
	pDestination := ADR(
		TRANSMIT_1.SET_DRILL_BIT_THREAD_LENGTH_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "drill bit wing position (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 40.0,
	pDestination := ADR(
		TRANSMIT_1.SET_DRILL_BIT_WING_POSITION_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "UC end retract hard (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_UC_END_RETRACT_HARD_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "UC end retract soft (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_UC_END_RETRACT_SOFT_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "drill bit load protrusion (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_1.SET_DRILL_BIT_LOAD_PROTRUSION_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "hard soil bit drive protrusion (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -50.0,
	lrMaximum := 50.0,
	pDestination := ADR(
		TRANSMIT_1.SET_DRILL_BIT_DRIVE_PROTRUSION_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;

IF NOT parseRealSetting(
	wsKey := "soft soil bit drive protrusion (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_BIT_PROTRUSION_VALUE
	)
) THEN
	parseDrillSettings := FALSE;
	// if xRequired:
	RETURN;
END_IF;

IF NOT parseSintSetting(
	wsKey := "soft soil cone tip protrusion (cm)",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -128.0,
	lrMaximum := 127.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[
			SOFT_SOIL_CONE_TIP_PROTRUSION
		]
	)
) THEN
	parseDrillSettings := FALSE;
	RETURN;
END_IF;