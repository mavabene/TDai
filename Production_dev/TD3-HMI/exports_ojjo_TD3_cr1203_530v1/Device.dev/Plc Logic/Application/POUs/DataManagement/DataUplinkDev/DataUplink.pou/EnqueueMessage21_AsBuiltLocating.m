
(********************** Declaration ****************************)
METHOD EnqueueMessage21_AsBuiltLocating : BOOL
VAR_INPUT
    stFoundation : sAsBuiltFoundationEvent;
END_VAR


(********************** Implementation ****************************)


IF NOT StartPayload(uiMessageId := 21, sPreScrewId := '') THEN
    EnqueueMessage21_AsBuiltLocating := FALSE;
    RETURN;
END_IF
IF stFoundation.iEventType = eDataCollection.TA_COLLECT_TRACK_TO_RWP THEN
	AddStringField(sName := 'event_type', sValue := 'Track_locating');
ELSIF stFoundation.iEventType = eDataCollection.TA_COLLECT_RWP_TO_SCREW THEN
	AddStringField(sName := 'event_type', sValue := 'RWP_locating');
ELSE // crimp
	AddStringField(sName := 'event_type', sValue := 'Foundation_locating');
END_IF
AddStringField(sName := 'PNEZD_P', sValue := stFoundation.sPnezdP);
AddNumberTextField(sName := 'Latitude', sValue := TO_STRING(stFoundation.rLatitude));
AddNumberTextField(sName := 'Longitude', sValue := TO_STRING(stFoundation.rLongitude));


AddNumberTextField(sName := 'XOffset', sValue := TO_STRING(stFoundation.rXOffset));
AddNumberTextField(sName := 'YOffset', sValue := TO_STRING(stFoundation.rYOffset));
AddNumberTextField(sName := 'ZOffset', sValue := TO_STRING(stFoundation.rZOffset));
AddNumberTextField(sName := 'YawOffset', sValue := TO_STRING(stFoundation.rYawOffset));

AddNumberTextField(sName := 'PNEZD_N', sValue := TO_STRING(stFoundation.rPnezdNorthing));
AddNumberTextField(sName := 'PNEZD_E', sValue := TO_STRING(stFoundation.rPnezdEasting));
AddNumberTextField(sName := 'PNEZD_Z', sValue := TO_STRING(stFoundation.rPnezdHeight));
AddStringField(sName := 'PNEZD_D', sValue := stFoundation.sPnezdDescription);

AddBoolField(sName := 'RTKFixed', xValue := stFoundation.xRtkFixed);
AddNumberTextField(sName := 'RTKDelay', sValue := TO_STRING(stFoundation.usiRadioSignalDelay));
AddNumberTextField(sName := 'HRMS', sValue := TO_STRING(stFoundation.iHrms));
AddNumberTextField(sName := 'VRMS', sValue := TO_STRING(stFoundation.iVrms));
AddNumberTextField(sName := 'PDOP', sValue := TO_STRING(stFoundation.rPdop));
AddNumberTextField(sName := 'SatelliteCount', sValue := TO_STRING(stFoundation.usiSatelliteCount));

AddNumberTextField(sName := 'MastRoll', sValue := TO_STRING(stFoundation.rMastRoll));
AddNumberTextField(sName := 'MastPitch', sValue := TO_STRING(stFoundation.rCorrectedMastPitch));
AddNumberTextField(sName := 'GPSYaw', sValue := TO_STRING(stFoundation.rGpsYaw));

AddNumberTextField(sName := 'CycleTime', sValue := TO_STRING(stFoundation.uiTotalCycleTime));

AddNumberTextField(sName := 'XSlidePosition', sValue := TO_STRING(stFoundation.rFinalXSlidePosition));
AddNumberTextField(sName := 'BoomSwingPosition', sValue := TO_STRING(stFoundation.rFinalBoomSwingPosition));
AddNumberTextField(sName := 'YawArmPosition', sValue := TO_STRING(stFoundation.rFinalYawPosition));
AddNumberTextField(sName := 'ZSlidePosition', sValue := TO_STRING(stFoundation.rFinalZSlidePosition));

AddNumberTextField(sName := 'TrackAssistFlag', sValue := TO_STRING(stFoundation.usiTrackAssistStatus));

EnqueueMessage21_AsBuiltLocating :=
    FinishPayload(uiMessageId := 21, uiPriority := 1);