
(********************** Declaration ****************************)
METHOD EnqueueMessage14 : BOOL
VAR_INPUT
    TIME_SINCE_MACHINE_POWER_ON : REAL;
END_VAR
VAR
    sLocalScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
sLocalScrewId := TO_STRING(RECEIVE_1.SCREW_NUMBER_TRANSMIT);

IF NOT StartPayload(uiMessageId := 14, sPreScrewId := sLocalScrewId) THEN
    EnqueueMessage14 := FALSE;
    RETURN;
END_IF

AddNumberTextField(sName := 'TimeSinceMachinePowerOn', sValue := TO_STRING(TIME_SINCE_MACHINE_POWER_ON));
AddNumberTextField(sName := 'GPSLat', sValue := TO_STRING(RECEIVE_1.LATITUDE));
AddNumberTextField(sName := 'GPSLong', sValue := TO_STRING(RECEIVE_1.LONGITUDE));

EnqueueMessage14 := FinishPayload(uiMessageId := 14, uiPriority := 2);