
(********************** Declaration ****************************)
METHOD EnqueueMessage2 : BOOL
VAR
    sLocalScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
sLocalScrewId := TO_STRING(RECEIVE_1.SCREW_NUMBER_TRANSMIT);

IF NOT StartPayload(uiMessageId := 2, sPreScrewId := sLocalScrewId) THEN
    EnqueueMessage2 := FALSE;
    RETURN;
END_IF

AddStringField(sName := 'ScrewMachineId', sValue := sMachineId);
AddNumberTextField(sName := 'GPSLat', sValue := TO_STRING(RECEIVE_1.LATITUDE));
AddNumberTextField(sName := 'GPSLong', sValue := TO_STRING(RECEIVE_1.LONGITUDE));
AddStringField(sName := 'FileTimestamp', sValue := READABLE_TIME);
AddNumberTextField(sName := 'ScrewDriveUpdateRateHz', sValue := TO_STRING(10 / DATA_ACQ_FREQ_DIVISOR));
AddStringField(sName := 'PLCVersion', sValue := PLC_VERSION);
AddStringField(sName := 'HMIVersion', sValue := VersionHMI.VERSION);
AddStringField(sName := 'GPS_PNEZD_P', sValue := RECEIVE_7_GPS.GPS_PNEZD_P);
AddNumberTextField(sName := 'GPS_PNEZD_N', sValue := TO_STRING(RECEIVE_7_GPS.GPS_PNEZD_N));
AddNumberTextField(sName := 'GPS_PNEZD_E', sValue := TO_STRING(RECEIVE_7_GPS.GPS_PNEZD_E));
AddNumberTextField(sName := 'GPS_PNEZD_Z', sValue := TO_STRING(RECEIVE_7_GPS.GPS_PNEZD_Z));
AddStringField(sName := 'GPS_PNEZD_D', sValue := RECEIVE_7_GPS.GPS_PNEZD_D);

EnqueueMessage2 := FinishPayload(uiMessageId := 2, uiPriority := 1);