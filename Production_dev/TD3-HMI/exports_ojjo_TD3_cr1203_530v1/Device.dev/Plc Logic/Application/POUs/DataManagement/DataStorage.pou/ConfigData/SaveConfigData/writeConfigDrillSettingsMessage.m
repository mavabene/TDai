
(********************** Declaration ****************************)
(* This message gets written upon crimping 	 *)
METHOD writeConfigDrillSettingsMessage : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
(* Header *)

DATA := '{$R$N';

writeConfigHeaderMessage(
	sVersionKey := 'Drill Config Version',
	iFormatVersion := TRANSMIT_2.SET_HMI_STRINGS[DRILL_SETTINGS_CONFIG_VERSION]
);

(* ======================================================== *)
(* ------------------------- DATA ------------------------- *)
(* ======================================================== *)

appendConfigField(
	sKey := 'drill bit length (cm)',
	sValue := TO_STRING(
		RECEIVE_2.DRILL_BIT_LENGTH_VALUE
	)
);

appendConfigField(
	sKey := 'drill bit thread length (cm)',
	sValue := TO_STRING(
		RECEIVE_2.DRILL_BIT_THREAD_LENGTH_VALUE
	)
);

appendConfigField(
	sKey := 'drill bit wing position (cm)',
	sValue := TO_STRING(
		RECEIVE_2.DRILL_BIT_WING_POSITION_VALUE
	)
);

appendConfigField(
	sKey := 'UC end retract hard (cm)',
	sValue := TO_STRING(
		RECEIVE_2.UC_END_RETRACT_HARD_VALUE
	)
);

appendConfigField(
	sKey := 'UC end retract soft (cm)',
	sValue := TO_STRING(
		RECEIVE_2.UC_END_RETRACT_SOFT_VALUE
	)
);

appendConfigField(
	sKey := 'drill bit load protrusion (cm)',
	sValue := TO_STRING(
		RECEIVE_2.DRILL_BIT_LOAD_PROTRUSION_VALUE
	)
);

appendConfigField(
	sKey := 'hard soil bit drive protrusion (cm)',
	sValue := TO_STRING(
		RECEIVE_2.DRILL_BIT_DRIVE_PROTRUSION_VALUE
	)
);

appendConfigField(
	sKey := 'soft soil bit drive protrusion (cm)',
	sValue := TO_STRING(
		RECEIVE_2.SS_BIT_PROTRUSION_VALUE
	)
);

appendConfigField(
	sKey := 'soft soil cone tip protrusion (cm)',
	sValue := TO_STRING(
		RECEIVE_6.HMI_SINTS_VALUES[
			SOFT_SOIL_CONE_TIP_PROTRUSION
		]
	)
);

(* =========================================================================== *)
(*  -------- Close JSON object - previous fields are interchangeable --------  *)
(* =========================================================================== *)


APPEND := '  "Drill settings config end": true$R$N';
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
