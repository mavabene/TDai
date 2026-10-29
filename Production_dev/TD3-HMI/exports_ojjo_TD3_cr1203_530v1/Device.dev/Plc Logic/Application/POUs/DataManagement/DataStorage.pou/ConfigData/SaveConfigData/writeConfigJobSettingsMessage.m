
(********************** Declaration ****************************)
(* This message gets written upon crimping 	 *)
METHOD writeConfigJobSettingsMessage : BOOL
VAR_INPUT
	
END_VAR
VAR
	i : INT;
	sKey : STRING(255);
END_VAR

(********************** Implementation ****************************)
writeConfigJobSettingsMessage := TRUE;

DATA := '{$R$N';

writeConfigHeaderMessage(
	sVersionKey := 'Job Config Version',
	iFormatVersion := TRANSMIT_2.SET_HMI_STRINGS[JOB_SETTINGS_CONFIG_VERSION]
);

(* ======================================================== *)
(* ------------------------- DATA ------------------------- *)
(* ======================================================== *)


(* ======================================================== *)
(* Screw lengths and embedments                             *)
(* ======================================================== *)

FOR i := 1 TO 3 DO

	sKey := CONCAT(
		'screw length ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_5.SCREW_LENGTHS_CM_VALUE[i]
		)
	);

END_FOR;


FOR i := 1 TO 3 DO

	sKey := CONCAT(
		'standard embedment ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_5.STANDARD_EMBEDMENT_CM_VALUE[i]
		)
	);

END_FOR;


FOR i := 1 TO 3 DO

	sKey := CONCAT(
		'heavy embedment ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_5.HEAVY_EMBEDMENT_CM_VALUE[i]
		)
	);

END_FOR;


(* ======================================================== *)
(* Screw and crowd geometry                                 *)
(* ======================================================== *)



appendConfigField(
	sKey := 'rotator screw position',
	sValue := TO_STRING(
		RECEIVE_2.ROTATOR_SCREW_POS_VALUE
	)
);

appendConfigField(
	sKey := 'screw stop threshold',
	sValue := TO_STRING(
		RECEIVE_2.SCREW_STOP_THRESHOLD_VALUE
	)
);

appendConfigField(
	sKey := 'chuck to target',
	sValue := TO_STRING(
		RECEIVE_2.CHUCK_TO_TARGET_VALUE
	)
);

appendConfigField(
	sKey := 'ATOL to workpoint',
	sValue := TO_STRING(
		RECEIVE_2.ATOL_TO_WP_VALUE
	)
);

appendConfigField(
	sKey := 'screw tip to ground',
	sValue := TO_STRING(
		RECEIVE_2.SCREW_TIP_TO_GROUND_VALUE
	)
);

appendConfigField(
	sKey := 'mast lean',
	sValue := TO_STRING(
		RECEIVE_2.MAST_LEAN_VALUE
	)
);


(* ======================================================== *)
(* Hammer and compressor                                    *)
(* ======================================================== *)

appendConfigBoolField(
	sKey := 'hammer enabled',
	xValue := RECEIVE_2.HAMMER_ENABLED_VALUE
);

appendConfigField(
	sKey := 'hammer control source',
	sValue := TO_STRING(
		RECEIVE_2.HAMMER_CONTROL_SOURCE_VALUE
	)
);

appendConfigField(
	sKey := 'hammer on pressure',
	sValue := TO_STRING(
		RECEIVE_2.HAMMER_ON_PRESSURE_VALUE
	)
);

appendConfigField(
	sKey := 'hammer off pressure',
	sValue := TO_STRING(
		RECEIVE_2.HAMMER_OFF_PRESSURE_VALUE
	)
);

appendConfigBoolField(
	sKey := 'air compressor powered',
	xValue := RECEIVE_2.AIR_COMPRESSOR_POWERED_VALUE
);

appendConfigField(
	sKey := 'air on distance',
	sValue := TO_STRING(
		RECEIVE_2.AIR_ON_DISTANCE_VALUE
	)
);

appendConfigField(
	sKey := 'air off distance',
	sValue := TO_STRING(
		RECEIVE_2.AIR_OFF_DISTANCE_VALUE
	)
);

appendConfigBoolField(
	sKey := 'air flow reduced',
	xValue := RECEIVE_2.AIR_FLOW_REDUCED_VALUE
);

appendConfigField(
	sKey := 'air flow',
	sValue := TO_STRING(
		RECEIVE_2.AIR_FLOW_VALUE
	)
);

(* ======================================================== *)
(* Machine and operation selections                          *)
(* ======================================================== *)

appendConfigField(
	sKey := 'product install',
	sValue := TO_STRING(
		RECEIVE_2.PRODUCT_INSTALL_VALUE
	)
);

appendConfigBoolField(
	sKey := 'manual depth',
	xValue := RECEIVE_2.MANUAL_DEPTH_VALUE
);

appendConfigBoolField(
	sKey := 'embed reduction enabled',
	xValue := RECEIVE_2.EMBED_REDUCTION_ENABLED_VALUE
);

appendConfigField(
	sKey := 'embed reduction distance',
	sValue := TO_STRING(
		RECEIVE_2.EMBED_REDUCTION_DISTANCE_VALUE
	)
);

appendConfigField(
	sKey := 'embed reduction hysteresis',
	sValue := TO_STRING(
		RECEIVE_2.EMBED_REDUCTION_HYSTERESIS_VALUE
	)
);

appendConfigField(
	sKey := 'embed reduction minimum',
	sValue := TO_STRING(
		RECEIVE_2.EMBED_REDUCTION_MINIMUM_VALUE
	)
);


(* ======================================================== *)
(* Upper rotary stall settings                              *)
(* ======================================================== *)

appendConfigBoolField(
	sKey := 'UR stall enabled',
	xValue := RECEIVE_2.UR_STALL_ENABLED_VALUE
);

appendConfigField(
	sKey := 'UR stall pressure minimum',
	sValue := TO_STRING(
		RECEIVE_2.UR_STALL_P_MIN_VALUE
	)
);

appendConfigField(
	sKey := 'UR stall pressure time',
	sValue := TO_STRING(
		RECEIVE_2.UR_STALL_P_TIME_VALUE
	)
);

appendConfigField(
	sKey := 'UR stall pressure band',
	sValue := TO_STRING(
		RECEIVE_2.UR_STALL_P_BAND_VALUE
	)
);

appendConfigField(
	sKey := 'UR stall velocity maximum',
	sValue := TO_STRING(
		RECEIVE_2.UR_STALL_V_MAX_VALUE
	)
);

appendConfigField(
	sKey := 'UR stall velocity time',
	sValue := TO_STRING(
		RECEIVE_2.UR_STALL_V_TIME_VALUE
	)
);

appendConfigField(
	sKey := 'UR stall velocity band',
	sValue := TO_STRING(
		RECEIVE_2.UR_STALL_V_BAND_VALUE
	)
);


(* ======================================================== *)
(* Water settings                                            *)
(* ======================================================== *)

appendConfigBoolField(
	sKey := 'water used',
	xValue := RECEIVE_2.WATER_USED_VALUE
);

appendConfigField(
	sKey := 'water pump liters per minute',
	sValue := TO_STRING(
		RECEIVE_2.WATER_PUMP_LPM_VALUE
	)
);

appendConfigField(
	sKey := 'water drill liters per distance',
	sValue := TO_STRING(
		RECEIVE_2.WATER_DRILL_LPD_VALUE
	)
);

appendConfigField(
	sKey := 'water hover liters per time',
	sValue := TO_STRING(
		RECEIVE_2.WATER_HOVER_LPT_VALUE
	)
);

appendConfigField(
	sKey := 'water enter liters per time',
	sValue := TO_STRING(
		RECEIVE_2.WATER_ENTER_LPT_VALUE
	)
);

appendConfigField(
	sKey := 'water hammer ratio',
	sValue := TO_STRING(
		RECEIVE_2.WATER_HAMMER_RATIO_VALUE
	)
);


(* ======================================================== *)
(* NXT and screw geometry                                   *)
(* ======================================================== *)

appendConfigField(
	sKey := 'NXT TLM 3L embedment',
	sValue := TO_STRING(
		RECEIVE_5.NXT_TLM_3L_EMBEDMENT_CM_VALUE
	)
);

appendConfigField(
	sKey := 'NXT TLM T ATOL to workpoint',
	sValue := TO_STRING(
		RECEIVE_5.NXT_TLM_T_ATOL_TO_WP_VALUE
	)
);

appendConfigField(
	sKey := 'NXT TLM 3L ATOL to workpoint',
	sValue := TO_STRING(
		RECEIVE_5.NXT_TLM_3L_ATOL_TO_WP_VALUE
	)
);

appendConfigField(
	sKey := 'NXT TLM 3L heavy embedment',
	sValue := TO_STRING(
		RECEIVE_5.NXT_TLM_3L_HEAVY_EMBEDMENT_CM_VALUE
	)
);

appendConfigField(
	sKey := 'NXT TLM T angle',
	sValue := TO_STRING(
		RECEIVE_5.NXT_TLM_T_ANGLE_VALUE
	)
);

appendConfigField(
	sKey := 'screw pitch',
	sValue := TO_STRING(
		RECEIVE_3.SCREW_PITCH_VALUE
	)
);

appendConfigBoolField(
	sKey := 'soft soil enabled',
	xValue := RECEIVE_2.SOFT_SOIL_ENABLED_VALUE
);

appendConfigField(
	sKey := 'plumb screw embedment',
	sValue := TO_STRING(
		RECEIVE_2.PLUMB_SCREW_EMBEDMENT_VALUE
	)
);


(* ======================================================== *)
(* Soft-soil and drive settings                             *)
(* ======================================================== *)

appendConfigField(
	sKey := 'soft-soil drive velocity high',
	sValue := TO_STRING(
		RECEIVE_2.SS_DRIVE_VEL_HI_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil drive velocity low',
	sValue := TO_STRING(
		RECEIVE_2.SS_DRIVE_VEL_LOW_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd drive pressure high',
	sValue := TO_STRING(
		RECEIVE_2.LC_DRIVE_PRESSURE_HI_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd drive pressure low',
	sValue := TO_STRING(
		RECEIVE_2.LC_DRIVE_PRESSURE_LOW_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil lower crowd preload',
	sValue := TO_STRING(
		RECEIVE_2.SS_LC_PRELOAD_VALUE
	)
);


appendConfigField(
	sKey := 'soft-soil lower crowd stall time',
	sValue := TO_STRING(
		RECEIVE_2.SS_LC_STALL_TIME_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil detect band',
	sValue := TO_STRING(
		RECEIVE_2.SS_DETECT_BAND_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil detect time',
	sValue := TO_STRING(
		RECEIVE_2.SS_DETECT_TIME_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil clear spoils',
	sValue := TO_STRING(
		RECEIVE_2.SS_CLEAR_SPOILS_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil lower crowd stall pressure',
	sValue := TO_STRING(
		RECEIVE_2.SS_LC_STALL_PRESSURE_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd stall rotary advance',
	sValue := TO_STRING(
		RECEIVE_2.LC_STALL_LR_ADVANCE_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd stall rotary output',
	sValue := TO_STRING(
		RECEIVE_2.LC_STALL_LR_OUTPUT_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil lower crowd control source',
	sValue := TO_STRING(
		RECEIVE_2.SS_LC_CONTROL_SOURCE_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil maximum stalls',
	sValue := TO_STRING(
		RECEIVE_2.SS_MAX_STALLS_VALUE
	)
);

appendConfigField(
	sKey := 'soft-soil reveal maximum stalls',
	sValue := TO_STRING(
		RECEIVE_2.SS_REVEAL_MAX_STALLS_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd drive velocity high',
	sValue := TO_STRING(
		RECEIVE_2.LC_DRIVE_VEL_HI_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd drive velocity low',
	sValue := TO_STRING(
		RECEIVE_2.LC_DRIVE_VEL_LOW_VALUE
	)
);

appendConfigField(
	sKey := 'upper rotary drive pressure high',
	sValue := TO_STRING(
		RECEIVE_2.UR_DRIVE_PRESSURE_HI_VALUE
	)
);

appendConfigField(
	sKey := 'upper rotary drive pressure low',
	sValue := TO_STRING(
		RECEIVE_2.UR_DRIVE_PRESSURE_LOW_VALUE
	)
);


(* ======================================================== *)
(* Packed Boolean settings                                  *)
(* ======================================================== *)

appendConfigBoolField(
	sKey := 'soft soil above ground air on',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		SOFT_SOIL_ABOVE_GROUND_AIR_ON
	]
);

appendConfigBoolField(
	sKey := 'soft soil cone on screw tip',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		SOFT_SOIL_CONE_ON_SCREW_TIP
	]
);

appendConfigBoolField(
	sKey := 'screw parameters source is PNEZD',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		SCREW_PARAMS_SOURCE_IS_PNEZD
	]
);

appendConfigBoolField(
	sKey := 'preload automatic mast lean compensation',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		PRELOAD_AUTO_MAST_LEAN_COMPENSATION
	]
);

appendConfigBoolField(
	sKey := 'proximity sensor installed',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		PROXIMITY_SENSOR_INSTALLED
	]
);

appendConfigBoolField(
	sKey := 'automatic preload on',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		AUTO_PRELOAD_ON
	]
);


(* ======================================================== *)
(* Packed SINT settings                                     *)
(* ======================================================== *)


appendConfigField(
	sKey := 'lower crowd stall detect mode',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			LC_STALL_DETECT_MODE
		]
	)
);


(* ======================================================== *)
(* Packed REAL settings                                     *)
(* ======================================================== *)

appendConfigField(
	sKey := 'NXT2 TLM 3L ATOL to workpoint',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			NXT2_TLM_3L_ATOL_TO_WP
		]
	)
);

appendConfigField(
	sKey := 'NXT2 TLM T ATOL to workpoint',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			NXT2_TLM_T_ATOL_TO_WP
		]
	)
);

appendConfigField(
	sKey := 'NXT INT variable motor 3L embedment',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			NXT_INT_VAR_MOTOR_3L_EMBED
		]
	)
);

appendConfigField(
	sKey := 'NXT VAR 3L angle',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			NXT_VAR_3L_ANGLE
		]
	)
);

appendConfigField(
	sKey := 'third leg angle compensation',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			THIRD_LEG_ANGLE_COMPENSATION
		]
	)
);


(* ======================================================== *)
(* Leg lengths and usage                                    *)
(* ======================================================== *)

FOR i := 1 TO 10 DO

	sKey := CONCAT(
		'leg length ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_2.LEG_LENGTHS_TRANSMIT[i]
		)
	);


	sKey := CONCAT(
		'leg length used ',
		TO_STRING(i)
	);

	appendConfigBoolField(
		sKey := sKey,
		xValue := RECEIVE_2.LEG_USED_TRANSMIT[i]
	);

END_FOR;


(* ======================================================== *)
(* Pressure and flow tables                                 *)
(* ======================================================== *)

FOR i := 1 TO 5 DO

	sKey := CONCAT(
		'UR pressure input ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_3.UR_PRESSURE_INPUT_VALUE[i]
		)
	);


	sKey := CONCAT(
		'air flow output ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_3.AIR_FLOW_OUTPUT_VALUE[i]
		)
	);

END_FOR;


(* =========================================================================== *)
(*  -------- Close JSON object - previous fields are interchangeable --------  *)
(* =========================================================================== *)


APPEND := '  "Job settings config end": true$R$N';
Stu.StrConcatA(
    ADR(APPEND),
    ADR(DATA),
    TO_INT(SIZEOF(DATA))
);

APPEND := '}$R$N';
Stu.StrConcatA(
    ADR(APPEND),
    ADR(DATA),
    TO_INT(SIZEOF(DATA))
);

write(FH := FH_CONFIG_DATA);
