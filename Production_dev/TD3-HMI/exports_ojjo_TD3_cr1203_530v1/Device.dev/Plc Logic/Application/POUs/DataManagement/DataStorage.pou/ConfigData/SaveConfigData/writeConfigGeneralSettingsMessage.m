
(********************** Declaration ****************************)
(* This message gets written upon crimping 	 *)
METHOD writeConfigGeneralSettingsMessage : BOOL
VAR_INPUT
END_VAR
VAR
	i : INT;
	j : INT;
END_VAR
(********************** Implementation ****************************)
writeConfigGeneralSettingsMessage := TRUE;

DATA := '{$R$N';

writeConfigHeaderMessage(
	sVersionKey := 'General Config Ver',
	iFormatVersion := TRANSMIT_2.SET_HMI_STRINGS[eHMI_SettingsStrings.GENERAL_SETTINGS_CONFIG_VERSION]
);

(* ======================================================== *)
(* Speeds and machine limits                               *)
(* ======================================================== *)

appendConfigBoolField(
	sKey := 'outrigger enabled',
	xValue := RECEIVE_2.OUTRIGGER_ENABLED_VALUE
);

appendConfigField(
	sKey := 'TCH down speed',
	sValue := TO_STRING(RECEIVE_2.TCH_DOWN_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'TCH up speed',
	sValue := TO_STRING(RECEIVE_2.TCH_UP_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'centralizer open speed',
	sValue := TO_STRING(RECEIVE_2.CENTRALIZER_OPEN_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'centralizer close speed',
	sValue := TO_STRING(RECEIVE_2.CENTRALIZER_CLOSE_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'left crimper open speed',
	sValue := TO_STRING(RECEIVE_2.CRIMPER_LEFT_OPEN_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'left crimper close speed',
	sValue := TO_STRING(RECEIVE_2.CRIMPER_LEFT_CLOSE_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'right crimper open speed',
	sValue := TO_STRING(RECEIVE_2.CRIMPER_RIGHT_OPEN_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'right crimper close speed',
	sValue := TO_STRING(RECEIVE_2.CRIMPER_RIGHT_CLOSE_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'upper rotary forward speed',
	sValue := TO_STRING(RECEIVE_2.UPPER_ROTARY_FWD_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'upper rotary reverse speed',
	sValue := TO_STRING(RECEIVE_2.UPPER_ROTARY_REV_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'blade up speed',
	sValue := TO_STRING(RECEIVE_2.BLADE_UP_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'blade down speed',
	sValue := TO_STRING(RECEIVE_2.BLADE_DOWN_SPEED_TRANSMIT)
);

appendConfigField(
	sKey := 'preload speed',
	sValue := TO_STRING(RECEIVE_2.PRELOAD_SPEED_VALUE)
);

appendConfigField(
	sKey := 'max roll start',
	sValue := TO_STRING(RECEIVE_2.MAX_ROLL_START_VALUE)
);

appendConfigField(
	sKey := 'max pitch forward start',
	sValue := TO_STRING(RECEIVE_2.MAX_PITCH_FWD_START_VALUE)
);

appendConfigField(
	sKey := 'max pitch backward start',
	sValue := TO_STRING(RECEIVE_2.MAX_PITCH_BACK_START_VALUE)
);

appendConfigField(
	sKey := 'max roll continue',
	sValue := TO_STRING(RECEIVE_2.MAX_ROLL_CONTINUE_VALUE)
);

appendConfigField(
	sKey := 'max pitch forward continue',
	sValue := TO_STRING(RECEIVE_2.MAX_PITCH_FWD_CONTINUE_VALUE)
);

appendConfigField(
	sKey := 'max pitch backward continue',
	sValue := TO_STRING(RECEIVE_2.MAX_PITCH_BACK_CONTINUE_VALUE)
);

appendConfigField(
	sKey := 'max boom swing start',
	sValue := TO_STRING(RECEIVE_2.MAX_BS_START_VALUE)
);


(* ======================================================== *)
(* GPS axis settings                                        *)
(* ======================================================== *)

appendConfigField(
	sKey := 'GPS autotarget selection',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AUTOTARGET_SELECTION_VALUE
	)
);

appendConfigField(
	sKey := 'GPS heading in range',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[1, 7]
	)
);

appendConfigField(
	sKey := 'GPS heading on target',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[1, 8]
	)
);

appendConfigField(
	sKey := 'GPS X in range',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[2, 7]
	)
);

appendConfigField(
	sKey := 'GPS X on target',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[2, 8]
	)
);

appendConfigField(
	sKey := 'GPS Y in range',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[3, 7]
	)
);

appendConfigField(
	sKey := 'GPS Y on target',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[3, 8]
	)
);

appendConfigField(
	sKey := 'GPS Z in range',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[4, 7]
	)
);

appendConfigField(
	sKey := 'GPS Z on target',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_AXES_SETTINGS_VALUES[4, 8]
	)
);


(* ======================================================== *)
(* GPS general settings                                    *)
(* ======================================================== *)

appendConfigField(
	sKey := 'GPS velocity factor',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[1]
	)
);

appendConfigField(
	sKey := 'GPS acceleration factor',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[2]
	)
);

appendConfigField(
	sKey := 'GPS radio signal delay warning',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[3]
	)
);

appendConfigField(
	sKey := 'GPS radio signal delay critical',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[4]
	)
);

appendConfigField(
	sKey := 'GPS transition to crimp factor',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[5]
	)
);

appendConfigField(
	sKey := 'GPS transition to feedback autotarget factor',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[6]
	)
);

appendConfigField(
	sKey := 'GPS mast pitch tolerance',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[11]
	)
);

appendConfigField(
	sKey := 'GPS mast roll tolerance',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[12]
	)
);

appendConfigField(
	sKey := 'GPS tracking X adjust',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[13]
	)
);

appendConfigField(
	sKey := 'GPS tracking Z adjust',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[14]
	)
);

appendConfigField(
	sKey := 'GPS data length',
	sValue := TO_STRING(
		RECEIVE_7_GPS.GPS_GENERAL_SETTINGS_VALUES[15]
	)
);


(* ======================================================== *)
(* Packed Boolean settings                                  *)
(* ======================================================== *)

appendConfigBoolField(
	sKey := 'FWP Z autotarget',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		FWP_Z_AUTOTARGET
	]
);

appendConfigBoolField(
	sKey := 'high WP allowed',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		HIGH_WP_ALLOWED
	]
);

appendConfigBoolField(
	sKey := 'TA auto mode advance',
	xValue := RECEIVE_6.HMI_BOOLS_VALUES[
		TA_AUTO_MODE_ADVANCE
	]
);


(* ======================================================== *)
(* Packed REAL settings                                     *)
(* ======================================================== *)

appendConfigField(
	sKey := 'TA pitch reduction angle',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			TA_PITCH_REDUCTION_ANGLE
		]
	)
);

appendConfigField(
	sKey := 'TA roll reduction angle',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			TA_ROLL_REDUCTION_ANGLE
		]
	)
);

appendConfigField(
	sKey := 'TA max speed',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			TA_MAX_SPEED
		]
	)
);

appendConfigField(
	sKey := 'TA correction aggression',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			TA_CORRECTION_AGGRESSION
		]
	)
);

appendConfigField(
	sKey := 'LC stall hammer time',
	sValue := TO_STRING(
		RECEIVE_6.HMI_REALS_VALUES[
			LC_STALL_HAMMER_TIME
		]
	)
);

appendConfigField(
	sKey := 'chuck to bushing',
	sValue := TO_STRING(
		RECEIVE_2.CHUCK_TO_BUSHING_VALUE
	)
);

(* ======================================================== *)
(* Packed SINT settings                                     *)
(* ======================================================== *)

appendConfigField(
	sKey := 'screw drive manual auto delay',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			SCREW_DRIVE_MAN_AUTO_DELAY
		]
	)
);

(* ================================================================= *)
(* Closing sentinel. This field intentionally has no trailing comma. *)
(* ================================================================= *)

APPEND := '  "General settings config end": true$R$N';

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