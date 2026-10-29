
(********************** Declaration ****************************)
METHOD parseJobSettings : BOOL
VAR_INPUT
	secondPass : BOOL;
END_VAR
VAR
	i : INT;
	sKey : STRING(255);
	wsKeyLocal : WSTRING(255);
END_VAR

(********************** Implementation ****************************)


parseJobSettings := TRUE;

(* ----- get settings format version ----- *)
IF NOT parseStringSetting(
    wsKey := "Job Config Version",
    secondPass := secondPass,
    xRequired := TRUE,
    uiMaximumLength := 20,
    uiDestinationCapacity :=
        SIZEOF(
            TRANSMIT_2.SET_HMI_STRINGS[JOB_SETTINGS_CONFIG_VERSION]
        ),
    pDestination :=
        ADR(
            TRANSMIT_2.SET_HMI_STRINGS[JOB_SETTINGS_CONFIG_VERSION]
        )
) THEN

    parseJobSettings := FALSE;
    RETURN;
END_IF;

// (* ----- get format version ----- *)
// IF NOT parseStringSetting20(
// 	wsKey := "Job Config Version",
// 	secondPass := secondPass,
// 	xRequired := TRUE,
// 	uiMaximumLength := 20,
// 	pDestination := ADR(
// 		TRANSMIT_2.SET_HMI_STRINGS[eHMI_SettingsStrings.JOB_SETTINGS_CONFIG_VERSION]
// 	)
// ) THEN
// 	parseJobSettings := FALSE;
// 	RETURN;
// END_IF;

(* ======================================================== *)
(* Screw lengths and embedments                             *)
(* ======================================================== *)

FOR i := 1 TO 3 DO

	sKey := CONCAT(
		'screw length ',
		TO_STRING(i)
	);
	wsKeyLocal := STRING_TO_WSTRING(sKey);

	IF NOT parseRealSetting(
		wsKey := wsKeyLocal,
		secondPass := secondPass,
		xRequired := TRUE,
		lrMinimum := 0.0,
		lrMaximum := 400.0,
		pDestination := ADR(
			TRANSMIT_2.SET_SCREW_LENGTHS_CM_VALUES[i]
		)
	) THEN
		parseJobSettings := FALSE;
		RETURN;
	END_IF;

END_FOR;
IF NOT parseJobSettings THEN
	RETURN;
END_IF

FOR i := 1 TO 3 DO

	sKey := CONCAT(
		'standard embedment ',
		TO_STRING(i)
	);
	wsKeyLocal := STRING_TO_WSTRING(sKey);

	IF NOT parseRealSetting(
		wsKey := wsKeyLocal,
		secondPass := secondPass,
		xRequired := TRUE,
		lrMinimum := 0.0,
		lrMaximum := 300.0,
		pDestination := ADR(
			TRANSMIT_2.SET_STANDARD_EMBEDMENT_CM_VALUES[i]
		)
	) THEN
		parseJobSettings := FALSE;
		RETURN;
	END_IF;
IF NOT parseJobSettings THEN
	RETURN;
END_IF
END_FOR;


FOR i := 1 TO 3 DO

	sKey := CONCAT(
		'heavy embedment ',
		TO_STRING(i)
	);
	wsKeyLocal := STRING_TO_WSTRING(sKey);

	IF NOT parseRealSetting(
		wsKey := wsKeyLocal,
		secondPass := secondPass,
		xRequired := TRUE,
		lrMinimum := 0.0,
		lrMaximum := 400.0,
		pDestination := ADR(
			TRANSMIT_2.SET_HEAVY_EMBEDMENT_CM_VALUES[i]
		)
	) THEN
		parseJobSettings := FALSE;
		RETURN;
	END_IF;

END_FOR;


(* ======================================================== *)
(* Screw and crowd geometry                                 *)
(* ======================================================== *)




IF NOT parseRealSetting(
	wsKey := "rotator screw position",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 80.0,
	pDestination := ADR(
		TRANSMIT_2.SET_ROTATOR_SCREW_POS_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "screw stop threshold",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SCREW_STOP_THRESHOLD_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "chuck to target",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -100.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.SET_CHUCK_TO_TARGET_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "ATOL to workpoint",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_1.SET_ATOL_TO_WP_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "screw tip to ground",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -10.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.SET_SCREW_TIP_TO_GROUND_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "mast lean",
	secondPass := secondPass,
	xRequired := FALSE,
	lrMinimum := -10.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_MAST_LEAN_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Hammer and compressor                                    *)
(* ======================================================== *)

IF NOT parseBoolSetting(
	wsKey := "hammer enabled",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_HAMMER_ENABLED_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseIntSetting(
	wsKey := "hammer control source",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_1.SET_HAMMER_CONTROL_SOURCE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "hammer on pressure",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 6000.0,
	pDestination := ADR(
		TRANSMIT_1.SET_HAMMER_ON_PRESSURE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "hammer off pressure",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 6000.0,
	pDestination := ADR(
		TRANSMIT_1.SET_HAMMER_OFF_PRESSURE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "air compressor powered",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_AIR_COMPRESSOR_POWERED_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "air on distance",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -40.0,
	lrMaximum := 200.0,
	pDestination := ADR(
		TRANSMIT_1.SET_AIR_ON_DISTANCE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "air off distance",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_1.SET_AIR_OFF_DISTANCE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "air flow reduced",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_AIR_FLOW_REDUCED_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseIntSetting(
	wsKey := "air flow",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 200.0,
	pDestination := ADR(
		TRANSMIT_1.SET_AIR_FLOW_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Machine and operation selections                          *)
(* ======================================================== *)

IF NOT parseIntSetting(
	wsKey := "product install",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 50.0,
	pDestination := ADR(
		TRANSMIT_1.SET_PRODUCT_INSTALL_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "manual depth",
	secondPass := secondPass,
	xRequired := FALSE,
	pDestination := ADR(
		TRANSMIT_1.SET_MANUAL_DEPTH_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "embed reduction enabled",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_EMBED_REDUCTION_ENABLED_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "embed reduction distance",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_1.SET_EMBED_REDUCTION_DISTANCE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "embed reduction hysteresis",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.SET_EMBED_REDUCTION_HYSTERESIS_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "embed reduction minimum",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 250.0,
	pDestination := ADR(
		TRANSMIT_1.SET_EMBED_REDUCTION_MINIMUM_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Upper rotary stall settings                               *)
(* ======================================================== *)

IF NOT parseBoolSetting(
	wsKey := "UR stall enabled",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_UR_STALL_ENABLED_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "UR stall pressure minimum",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 5000.0,
	pDestination := ADR(
		TRANSMIT_1.SET_UR_STALL_P_MIN_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "UR stall pressure time",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_1.SET_UR_STALL_P_TIME_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "UR stall pressure band",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 4000.0,
	pDestination := ADR(
		TRANSMIT_1.SET_UR_STALL_P_BAND_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "UR stall velocity maximum",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.SET_UR_STALL_V_MAX_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "UR stall velocity time",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_1.SET_UR_STALL_V_TIME_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "UR stall velocity band",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_1.SET_UR_STALL_V_BAND_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Water settings                                            *)
(* ======================================================== *)

IF NOT parseBoolSetting(
	wsKey := "water used",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_WATER_USED_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "water pump liters per minute",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 1.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.SET_WATER_PUMP_LPM_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "water drill liters per distance",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_1.SET_WATER_DRILL_LPD_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "water hover liters per time",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_1.SET_WATER_HOVER_LPT_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "water enter liters per time",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_1.SET_WATER_ENTER_LPT_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "water hammer ratio",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -100.0,
	lrMaximum := 500.0,
	pDestination := ADR(
		TRANSMIT_1.SET_WATER_HAMMER_RATIO_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* NXT and screw geometry                                   *)
(* ======================================================== *)

IF NOT parseRealSetting(
	wsKey := "NXT TLM 3L embedment",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_2.SET_NXT_TLM_3L_EMBEDMENT_CM_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "NXT TLM T ATOL to workpoint",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_NXT_TLM_T_ATOL_TO_WP_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "NXT TLM 3L ATOL to workpoint",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_NXT_TLM_3L_ATOL_TO_WP_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "NXT TLM 3L heavy embedment",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_2.SET_NXT_TLM_3L_HEAVY_EMBEDMENT_CM_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "NXT TLM T angle",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 80.0,
	pDestination := ADR(
		TRANSMIT_2.SET_NXT_TLM_T_ANGLE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "screw pitch",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 50.0,
	pDestination := ADR(
		TRANSMIT_1.SET_SCREW_PITCH_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "soft soil enabled",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_1.SET_SOFT_SOIL_ENABLED_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "plumb screw embedment",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 500.0,
	pDestination := ADR(
		TRANSMIT_1.SET_PLUMB_SCREW_EMBEDMENT_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Soft-soil and drive settings                             *)
(* ======================================================== *)

IF NOT parseRealSetting(
	wsKey := "soft-soil drive velocity high",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_DRIVE_VEL_HI_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "soft-soil drive velocity low",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_DRIVE_VEL_LOW_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "lower crowd drive pressure high",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 3000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_LC_DRIVE_PRESSURE_HI_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "lower crowd drive pressure low",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 3000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_LC_DRIVE_PRESSURE_LOW_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "soft-soil lower crowd preload",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 40.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_LC_PRELOAD_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "soft-soil lower crowd stall time",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 20.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_LC_STALL_TIME_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "soft-soil detect band",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 4000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_DETECT_BAND_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "soft-soil detect time",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.2,
	lrMaximum := 30.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_DETECT_TIME_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "soft-soil clear spoils",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -25.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_CLEAR_SPOILS_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "soft-soil lower crowd stall pressure",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 5000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_LC_STALL_PRESSURE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseIntSetting(
	wsKey := "lower crowd stall rotary advance",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 180.0,
	pDestination := ADR(
		TRANSMIT_1.SET_LC_STALL_LR_ADVANCE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseIntSetting(
	wsKey := "lower crowd stall rotary output",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 100.0,
	pDestination := ADR(
		TRANSMIT_1.SET_LC_STALL_LR_OUTPUT_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseIntSetting(
	wsKey := "soft-soil lower crowd control source",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 1.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_LC_CONTROL_SOURCE_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseIntSetting(
	wsKey := "soft-soil maximum stalls",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_MAX_STALLS_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseIntSetting(
	wsKey := "soft-soil reveal maximum stalls",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_SS_REVEAL_MAX_STALLS_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "lower crowd drive velocity high",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_LC_DRIVE_VEL_HI_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "lower crowd drive velocity low",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_LC_DRIVE_VEL_LOW_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "upper rotary drive pressure high",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 3000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_UR_DRIVE_PRESSURE_HI_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "upper rotary drive pressure low",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 3000.0,
	pDestination := ADR(
		TRANSMIT_2.SET_UR_DRIVE_PRESSURE_LOW_VALUE
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Packed Boolean settings                                  *)
(* ======================================================== *)

IF NOT parseBoolSetting(
	wsKey := "soft soil above ground air on",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[
			SOFT_SOIL_ABOVE_GROUND_AIR_ON
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "soft soil cone on screw tip",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[
			SOFT_SOIL_CONE_ON_SCREW_TIP
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "screw parameters source is PNEZD",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[
			SCREW_PARAMS_SOURCE_IS_PNEZD
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "preload automatic mast lean compensation",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[
			PRELOAD_AUTO_MAST_LEAN_COMPENSATION
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "proximity sensor installed",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[
			PROXIMITY_SENSOR_INSTALLED
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseBoolSetting(
	wsKey := "automatic preload on",
	secondPass := secondPass,
	xRequired := TRUE,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_BOOLS[
			AUTO_PRELOAD_ON
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Packed SINT settings                                     *)
(* ======================================================== *)


IF NOT parseSintSetting(
	wsKey := "lower crowd stall detect mode",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := 0.0,
	lrMaximum := 2.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_SINTS[
			LC_STALL_DETECT_MODE
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Packed REAL settings                                     *)
(* ======================================================== *)

IF NOT parseRealSetting(
	wsKey := "NXT2 TLM 3L ATOL to workpoint",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1.0,
	lrMaximum := 200.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[
			NXT2_TLM_3L_ATOL_TO_WP
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "NXT2 TLM T ATOL to workpoint",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1.0,
	lrMaximum := 200.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[
			NXT2_TLM_T_ATOL_TO_WP
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "NXT INT variable motor 3L embedment",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1.0,
	lrMaximum := 300.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[
			NXT_INT_VAR_MOTOR_3L_EMBED
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "NXT VAR 3L angle",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1.0,
	lrMaximum := 70.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[
			NXT_VAR_3L_ANGLE
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


IF NOT parseRealSetting(
	wsKey := "third leg angle compensation",
	secondPass := secondPass,
	xRequired := TRUE,
	lrMinimum := -1.0,
	lrMaximum := 10.0,
	pDestination := ADR(
		TRANSMIT_2.SET_HMI_REALS[
			THIRD_LEG_ANGLE_COMPENSATION
		]
	)
) THEN
	parseJobSettings := FALSE;
	RETURN;
END_IF;


(* ======================================================== *)
(* Leg lengths and whether each length is used               *)
(* ======================================================== *)

FOR i := 1 TO 10 DO

	sKey := CONCAT(
		'leg length ',
		TO_STRING(i)
	);
	wsKeyLocal := STRING_TO_WSTRING(sKey);

	IF NOT parseRealSetting(
		wsKey := wsKeyLocal,
		secondPass := secondPass,
		xRequired := TRUE,
		lrMinimum := 0.0,
		lrMaximum := 300.0,
		pDestination := ADR(
			TRANSMIT_2.HMI_LEG_LENGTHS_CM[i]
		)
	) THEN
		parseJobSettings := FALSE;
		RETURN;
	END_IF;


	sKey := CONCAT(
		'leg length used ',
		TO_STRING(i)
	);
	wsKeyLocal := STRING_TO_WSTRING(sKey);

	IF NOT parseBoolSetting(
		wsKey := wsKeyLocal,
		secondPass := secondPass,
		xRequired := TRUE,
		pDestination := ADR(
			TRANSMIT_2.HMI_LEG_LENGTH_USED[i]
		)
	) THEN
		parseJobSettings := FALSE;
		RETURN;
	END_IF;

END_FOR;


(* ======================================================== *)
(* Pressure and flow tables                                 *)
(* ======================================================== *)

FOR i := 1 TO 5 DO

	sKey := CONCAT(
		'UR pressure input ',
		TO_STRING(i)
	);
	wsKeyLocal := STRING_TO_WSTRING(sKey);

	IF NOT parseRealSetting(
		wsKey := wsKeyLocal,
		secondPass := secondPass,
		xRequired := TRUE,
		lrMinimum := 0.0,
		lrMaximum := 5000.0,
		pDestination := ADR(
			TRANSMIT_2.SET_UR_PRESSURE_INPUT_VALUE[i]
		)
	) THEN
		parseJobSettings := FALSE;
		RETURN;
	END_IF;


	sKey := CONCAT(
		'air flow output ',
		TO_STRING(i)
	);
	wsKeyLocal := STRING_TO_WSTRING(sKey);

	IF NOT parseRealSetting(
		wsKey := wsKeyLocal,
		secondPass := secondPass,
		xRequired := TRUE,
		lrMinimum := 0.0,
		lrMaximum := 100.0,
		pDestination := ADR(
			TRANSMIT_2.SET_AIR_FLOW_OUTPUT_VALUE[i]
		)
	) THEN
		parseJobSettings := FALSE;
		RETURN;
	END_IF;

END_FOR;