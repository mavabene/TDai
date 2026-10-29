
(********************** Declaration ****************************)
METHOD BuildHmiStatusPayload : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF xPayloadBuildBusy THEN
    BuildHmiStatusPayload := FALSE; 
    RETURN;
END_IF

xPayloadBuildBusy := TRUE;

BuildTimestampUtc();

IF NOT xHmiOnlineSinceValid THEN
    sHmiOnlineSinceUtc := sTimestampUtc;
    xHmiOnlineSinceValid := TRUE;
END_IF

sBuildPayload := '{';
xBuildOk := TRUE;
xBuildFirstDataField := TRUE;

AddStringField(sName := 'state', sValue := 'online');
AddStringField(sName := 'since', sValue := sHmiOnlineSinceUtc);
AddStringField(sName := 'lastUpdated', sValue := sTimestampUtc);
Append(sText := '}');

IF xBuildOk THEN
    BuildHmiStatusPayload := EnqueueControlPayload(
        uiMessageId := uiHmiStatusMessageId,
        wsTopic := wsHmiStatusTopicName,
        xRetain := TRUE,
        sPayload := sBuildPayload
    );

    IF BuildHmiStatusPayload THEN
        MQTT_HMI_STATUS_PUBLISH_ENQUEUED := MQTT_HMI_STATUS_PUBLISH_ENQUEUED + 1;
    END_IF
ELSE
    udiBuildErrors := udiBuildErrors + 1;
    BuildHmiStatusPayload := FALSE;
END_IF

xPayloadBuildBusy := FALSE;