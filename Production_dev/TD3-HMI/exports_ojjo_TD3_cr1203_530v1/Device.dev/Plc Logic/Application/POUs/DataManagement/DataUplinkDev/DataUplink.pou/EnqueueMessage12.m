
(********************** Declaration ****************************)
METHOD EnqueueMessage12 : BOOL
VAR
    sLocalScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
sLocalScrewId := TO_STRING(RECEIVE_1.SCREW_NUMBER_TRANSMIT);

IF NOT StartPayload(uiMessageId := 12, sPreScrewId := sLocalScrewId) THEN
    EnqueueMessage12 := FALSE;
    RETURN;
END_IF

AddNumberTextField(sName := 'NoPurposeFirstCol', sValue := '1');
AddNumberTextField(sName := 'CurrentEmbedment', sValue := TO_STRING(RECEIVE_3.DRIVE_CURRENT_EMBEDMENT));
AddNumberTextField(sName := 'DriveTime', sValue := TO_STRING(RECEIVE_3.DRIVE_TIME));
AddNumberTextField(sName := 'GPSLat', sValue := TO_STRING(RECEIVE_1.LATITUDE));
AddNumberTextField(sName := 'GPSLong', sValue := TO_STRING(RECEIVE_1.LONGITUDE));
AddBoolField(sName := 'EmbedmentReductionDetected', xValue := RECEIVE_3.EMBED_REDUCTION_DETECTED);
AddNumberTextField(sName := 'EmbedmentReduction', sValue := TO_STRING(RECEIVE_3.EMBEDMENT_REDUCTION));
AddNumberTextField(sName := 'EmbedmentReductionStructural', sValue := TO_STRING(RECEIVE_3.EMBEDMENT_REDUCTION_STRUCTURAL));
AddNumberTextField(sName := 'HammerDistance', sValue := TO_STRING(RECEIVE_3.HAMMER_DISTANCE));
AddNumberTextField(sName := 'WaterVolume', sValue := TO_STRING(RECEIVE_3.WATER_VOLUME_L));
AddNumberTextField(sName := 'DriveLegLength', sValue := TO_STRING(RECEIVE_1.DRIVE_LEG_LENGTH));

EnqueueMessage12 := FinishPayload(uiMessageId := 12, uiPriority := 1);