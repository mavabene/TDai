
(********************** Declaration ****************************)
(* This message gets written upon crimping 	 *)
METHOD writeConfigMachineSpecificMessage : BOOL
VAR_INPUT
	
END_VAR
VAR
	i : INT;
	sKey : STRING(255);
END_VAR
(********************** Implementation ****************************)
writeConfigMachineSpecificMessage := TRUE;

DATA := '{$R$N';


writeConfigHeaderMessage(
	sVersionKey := 'TD Config Version',
	iFormatVersion :=
		TRANSMIT_2.SET_HMI_STRINGS[eHMI_SettingsStrings.TD_SPECIFIC_SETTINGS_CONFIG_VERSION]
);

(* ======================================================== *)
(* ------------------------- DATA ------------------------- *)
(* ======================================================== *)

(* Machine version *)
appendConfigField(
	sKey := 'machine version',
	sValue := TO_STRING(
		TRANSMIT_1.SET_MACHINE_VERSION_VALUE
	)
);


(* ======================================================== *)
(* Encoder calibration                                     *)
(* ======================================================== *)

appendConfigField(
	sKey := 'z slide encoder zero',
	sValue := TO_STRING(
		RECEIVE_5.Z_SLIDE_ENCODER_AT_ZERO_VALUE
	)
);

appendConfigField(
	sKey := 'x slide encoder zero',
	sValue := TO_STRING(
		RECEIVE_5.X_SLIDE_ENCODER_AT_ZERO_VALUE
	)
);

appendConfigField(
	sKey := 'mast slide encoder at ref',
	sValue := TO_STRING(
		RECEIVE_5.MAST_SLIDE_ENCODER_AT_REF
	)
);

appendConfigField(
	sKey := 'mast slide encoder at zero',
	sValue := TO_STRING(
		RECEIVE_5.MAST_SLIDE_ENCODER_AT_ZERO_VALUE
	)
);

appendConfigField(
	sKey := 'yaw encoder at zero',
	sValue := TO_STRING(
		SET_YAW_ENCODER_AT_ZERO
	)
);

appendConfigField(
	sKey := 'lower crowd encoder at ref',
	sValue := TO_STRING(
		SET_LOWER_CROWD_ENCODER_AT_REF
	)
);

appendConfigField(
	sKey := 'lower crowd encoder at zero',
	sValue := TO_STRING(
		SET_LOWER_CROWD_ENCODER_AT_ZERO
	)
);

appendConfigField(
	sKey := 'upper crowd encoder at zero',
	sValue := TO_STRING(
		SET_UPPER_CROWD_ENCODER_AT_ZERO
	)
);

appendConfigField(
	sKey := 'boom swing encoder at zero',
	sValue := TO_STRING(
		SET_BOOM_SWING_ENCODER_AT_ZERO
	)
);

appendConfigField(
	sKey := 'boom lift encoder at zero',
	sValue := TO_STRING(
		TRANSMIT_2.SET_BOOM_LIFT_ENCODER_AT_ZERO
	)
);

appendConfigField(
	sKey := 'joint lift encoder at zero',
	sValue := TO_STRING(
		TRANSMIT_2.SET_JOINT_LIFT_ENCODER_AT_ZERO
	)
);

appendConfigField(
	sKey := 'LR encoder resolution',
	sValue := TO_STRING(
		SET_LR_ENCODER_RES_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd encoder type',
	sValue := TO_STRING(
		TRANSMIT_2.SET_LOWER_CROWD_ENCODER_TYPE_VALUE
	)
);

appendConfigField(
	sKey := 'boom lift encoder type',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			BOOM_LIFT_ENCODER_TYPE
		]
	)
);

appendConfigField(
	sKey := 'boom swing encoder type',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			BOOM_SWING_ENCODER_TYPE
		]
	)
);

appendConfigField(
	sKey := 'joint lift encoder type',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			JOINT_LIFT_ENCODER_TYPE
		]
	)
);

appendConfigField(
	sKey := 'upper crowd encoder type',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			UPPER_CROWD_ENCODER_TYPE
		]
	)
);

appendConfigField(
	sKey := 'yaw encoder type',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			YAW_ENCODER_TYPE
		]
	)
);


(* ======================================================== *)
(* Equipment types                                          *)
(* ======================================================== *)

appendConfigField(
	sKey := 'air compressor type',
	sValue := TO_STRING(
		TRANSMIT_1.SET_MACHINE_COMPRESSOR_VALUE
	)
);

appendConfigField(
	sKey := 'drifter type',
	sValue := TO_STRING(
		TRANSMIT_1.SET_MACHINE_DRIFTER_VALUE
	)
);

appendConfigField(
	sKey := 'lower rotary type',
	sValue := TO_STRING(
		TRANSMIT_1.SET_MACHINE_LR_VALUE
	)
);

appendConfigField(
	sKey := 'GPS vendor',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_VENDOR_VALUE
	)
);


(* ======================================================== *)
(* Dimensions and machine geometry                          *)
(* ======================================================== *)

appendConfigField(
	sKey := 'lower crowd COR position',
	sValue := TO_STRING(
		TRANSMIT_1.SET_LOWER_CROWD_COR_POS_VALUE
	)
);

appendConfigField(
	sKey := 'lower crowd mast to slide offset',
	sValue := TO_STRING(
		SET_LOWER_CROWD_MAST_TO_SLIDE_OFFSET
	)
);

appendConfigField(
	sKey := 'knuckle to mast pitch delta',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			KNUCKLE_TO_MAST_PITCH_DELTA
		]
	)
);


(* ======================================================== *)
(* Miscellaneous machine settings                          *)
(* ======================================================== *)

appendConfigField(
	sKey := 'hammer speed',
	sValue := TO_STRING(
		TRANSMIT_1.HMI_HAMMER_SPEED
	)
);

appendConfigField(
	sKey := 'screw number',
	sValue := TO_STRING(
		RECEIVE_1.SCREW_NUMBER_TRANSMIT
	)
);

appendConfigBoolField(
	sKey := 'load unload',
	xValue := TRANSMIT_1.SET_LOAD_UNLOAD_VALUE
);

appendConfigField(
	sKey := 'upper crowd drill steel',
	sValue := TO_STRING(
		RECEIVE_2.UPPER_CROWD_DRILL_STEEL_VALUE
	)
);

appendConfigField(
	sKey := 'right left difference',
	sValue := TO_STRING(
		RECEIVE_2.RIGHT_LEFT_DIFF_VALUE
	)
);


(* ======================================================== *)
(* PLC temperature and supply monitoring                    *)
(* ======================================================== *)

appendConfigField(
	sKey := 'PLC board temperature max',
	sValue := TO_STRING(
		RECEIVE_5.PLC_BOARD_TEMP_MAX_TRANSMIT
	)
);

appendConfigField(
	sKey := 'PLC chip temperature max',
	sValue := TO_STRING(
		RECEIVE_5.PLC_CHIP_TEMP_MAX_TRANSMIT
	)
);

appendConfigField(
	sKey := 'PLC board temperature min',
	sValue := TO_STRING(
		RECEIVE_5.PLC_BOARD_TEMP_MIN_TRANSMIT
	)
);

appendConfigField(
	sKey := 'PLC chip temperature min',
	sValue := TO_STRING(
		RECEIVE_5.PLC_CHIP_TEMP_MIN_TRANSMIT
	)
);

appendConfigField(
	sKey := 'VBB15 millivolts max',
	sValue := TO_STRING(
		RECEIVE_5.VBB15_MV_MAX_TRANSMIT
	)
);

appendConfigField(
	sKey := 'VBB30 millivolts max',
	sValue := TO_STRING(
		RECEIVE_5.VBB30_MV_MAX_TRANSMIT
	)
);

appendConfigField(
	sKey := 'VBB15 millivolts min',
	sValue := TO_STRING(
		RECEIVE_5.VBB15_MV_MIN_TRANSMIT
	)
);

appendConfigField(
	sKey := 'VBB30 millivolts min',
	sValue := TO_STRING(
		RECEIVE_5.VBB30_MV_MIN_TRANSMIT
	)
);

appendConfigField(
	sKey := 'air compressor temp max',
	sValue := TO_STRING(
		RECEIVE_5.AIR_COMPRESSOR_TEMP_MAX_TRANSMIT
	)
);

appendConfigField(
	sKey := 'air compressor pressure max',
	sValue := TO_STRING(
		RECEIVE_5.AIR_COMPRESSOR_PRESSURE_MAX_TRANSMIT
	)
);


(* ======================================================== *)
(* Leg and screw counts                                     *)
(* ======================================================== *)

FOR i := 1 TO 10 DO

	sKey := CONCAT(
		'leg length count ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_5.LEG_LENGTH_COUNT_TRANSMIT[i]
		)
	);

END_FOR;


FOR i := 1 TO 3 DO

	sKey := CONCAT(
		'screw length count ',
		TO_STRING(i)
	);

	appendConfigField(
		sKey := sKey,
		sValue := TO_STRING(
			RECEIVE_5.SCREW_LENGTH_COUNT_TRANSMIT[i]
		)
	);

END_FOR;


(* ======================================================== *)
(* GPS machine-specific offsets                            *)
(* ======================================================== *)

appendConfigField(
	sKey := 'GPS TD specific yaw offset',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[7]
	)
);

appendConfigField(
	sKey := 'GPS TD specific X offset',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[8]
	)
);

appendConfigField(
	sKey := 'GPS TD specific Y offset',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[9]
	)
);

appendConfigField(
	sKey := 'GPS TD specific Z offset',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[10]
	)
);


(* ======================================================== *)
(* Debug/version field                                      *)
(* ======================================================== *)

appendConfigField(
	sKey := 'try version',
	sValue := '"007"'
);


(* ================================================================= *)
(* Closing sentinel. This field intentionally has no trailing comma. *)
(* ================================================================= *)

APPEND := '  "Machine settings config end": true$R$N';

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