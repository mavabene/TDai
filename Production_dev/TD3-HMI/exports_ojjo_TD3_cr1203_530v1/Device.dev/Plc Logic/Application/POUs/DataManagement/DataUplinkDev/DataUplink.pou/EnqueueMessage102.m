
(********************** Declaration ****************************)
METHOD EnqueueMessage102 : BOOL
VAR_INPUT
    TIME_ELAPSED : REAL;
END_VAR

(********************** Implementation ****************************)
IF NOT StartPayload(uiMessageId := 102, sPreScrewId := '-1') THEN
    EnqueueMessage102 := FALSE;
    RETURN;
END_IF

AddStringField(sName := 'MachineId', sValue := sMachineId);
AddNumberTextField(sName := 'TimeElapsed', sValue := TO_STRING(TIME_ELAPSED));
AddNumberTextField(sName := 'GPSLat', sValue := TO_STRING(RECEIVE_1.LATITUDE));
AddNumberTextField(sName := 'GPSLong', sValue := TO_STRING(RECEIVE_1.LONGITUDE));
AddStringField(sName := 'Timestamp', sValue := READABLE_TIME);

EnqueueMessage102 := FinishPayload(uiMessageId := 102, uiPriority := 1);