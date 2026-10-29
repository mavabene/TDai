
(********************** Declaration ****************************)
METHOD EnqueueMessage103 : BOOL
VAR_INPUT
    STATE_NUMBER : INT;
    CYCLE_DATA : UINT;
    CYCLE_SCREW_ID : UDINT;
    CYCLE_SCREW_SIDE : INT;
    CYCLE_TRUSS_TYPE : INT;
    TIME_ELAPSED : REAL;
    CYCLE_TIME_ELAPSED : REAL;
END_VAR
VAR
    sPreScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
IF CYCLE_SCREW_ID > 0 THEN
    sPreScrewId := TO_STRING(CYCLE_SCREW_ID);
ELSE
    sPreScrewId := '-1';
END_IF

IF NOT StartPayload(uiMessageId := 103, sPreScrewId := sPreScrewId) THEN
    EnqueueMessage103 := FALSE;
    RETURN;
END_IF

AddNumberTextField(sName := 'StateNumber', sValue := TO_STRING(STATE_NUMBER));
AddNumberTextField(sName := 'CycleData', sValue := TO_STRING(CYCLE_DATA));
AddNumberTextField(sName := 'CycleScrewId', sValue := TO_STRING(CYCLE_SCREW_ID));
AddNumberTextField(sName := 'CycleScrewSide', sValue := TO_STRING(CYCLE_SCREW_SIDE));
AddNumberTextField(sName := 'CycleTrussType', sValue := TO_STRING(CYCLE_TRUSS_TYPE));
AddNumberTextField(sName := 'TimeElapsed', sValue := TO_STRING(TIME_ELAPSED));
AddNumberTextField(sName := 'CycleTimeElapsed', sValue := TO_STRING(CYCLE_TIME_ELAPSED));
AddNumberTextField(sName := 'GPSLat', sValue := TO_STRING(RECEIVE_1.LATITUDE));
AddNumberTextField(sName := 'GPSLong', sValue := TO_STRING(RECEIVE_1.LONGITUDE));
AddStringField(sName := 'Timestamp', sValue := READABLE_TIME);

EnqueueMessage103 := FinishPayload(uiMessageId := 103, uiPriority := 1);