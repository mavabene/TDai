
(********************** Declaration ****************************)
METHOD checkProximitySensorStatus : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// we are confirming a tag was detected at least once
IF 	(NOT HMI_BOOLS_VALUES[PROXIMITY_SENSOR_INSTALLED]) // not using proximity exclusion
	OR 
	(PROXIMITY_SENSOR_ALARM_ON AND NOT PROXIMITY_SENSOR_ON_ALARM_OFF) // alarm verified
	THEN
 	PROXIMITY_SENSOR_PRESENCE_CONFIRMED := TRUE;
// reset if switched to installed
ELSIF LAST_PROXIMITY_SENSOR_INSTALL_STATUS <> HMI_BOOLS_VALUES[PROXIMITY_SENSOR_INSTALLED] THEN 
	PROXIMITY_SENSOR_PRESENCE_CONFIRMED := FALSE;
END_IF
LAST_PROXIMITY_SENSOR_INSTALL_STATUS := HMI_BOOLS_VALUES[PROXIMITY_SENSOR_INSTALLED];


// PROXIMITY_SENSOR_STATUS_CONFIRMED := TRUE;