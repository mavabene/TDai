
(********************** Declaration ****************************)
METHOD updateMaxPressures
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF LOWER_CROWD_PRESSURE > DRIVE_MAX_LC_PRESSURE THEN
	DRIVE_MAX_LC_PRESSURE := LOWER_CROWD_PRESSURE;
END_IF
IF LOWER_ROTARY_PRESSURE > DRIVE_MAX_LR_PRESSURE THEN
	DRIVE_MAX_LR_PRESSURE := LOWER_ROTARY_PRESSURE;
	(* Drill Tech (Danfoss OMT250 motor):
	LR torque = (LR pressure lbf/in^2 * in^2 / 2900 lbf) * 2 motors * (6460 in lbf) * (1 ft / 12 in) * (1 / motors) 
	2900 = max pressure drop (EuroDrill(Eaton 4000 Series 205 Motors): 3000psi)
	6460 is max torque at 2900 psi for a motor (EuroDrill(Eaton 4000 Series 205 Motors): 5300in lbf )
	2 motors
	2.5 reduction ratio (EuroDrill: 2.52)
	*)
	// DRIVE_MAX_LR_TORQUE = 2*((LR Pressure/2900)*(6460/12)*2.5) =
	DRIVE_MAX_LR_TORQUE := DRIVE_MAX_LR_PRESSURE * 2 * 0.484;
	(* elsif Lower Rotary B then
		// DRIVE_MAX_LR_TORQUE = 2*((LR Pressure/3000)*(5300/12)*2.52) = 2 * 0.371
	*)
END_IF
IF UPPER_CROWD_PRESSURE > DRIVE_MAX_UC_PRESSURE THEN
	DRIVE_MAX_UC_PRESSURE := UPPER_CROWD_PRESSURE;
END_IF
IF UPPER_ROTARY_PRESSURE > DRIVE_MAX_UR_PRESSURE THEN
	DRIVE_MAX_UR_PRESSURE := UPPER_ROTARY_PRESSURE;
END_IF
// IF HAMMER_PRESSURE > DRIVE_MAX_HMR_PRESSURE THEN
// 	DRIVE_MAX_HMR_PRESSURE := HAMMER_PRESSURE;
// END_IF

