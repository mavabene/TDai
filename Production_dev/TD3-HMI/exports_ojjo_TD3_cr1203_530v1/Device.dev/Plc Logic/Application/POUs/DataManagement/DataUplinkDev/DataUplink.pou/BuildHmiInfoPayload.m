
(********************** Declaration ****************************)
METHOD BuildHmiInfoPayload : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
BuildHmiInfoPayload := FALSE;

IF LEN(MQTT_MACHINE_SERIAL) = 0 THEN
    RETURN;
END_IF

IF xPayloadBuildBusy THEN
    BuildHmiInfoPayload := FALSE; 
    RETURN;
END_IF

xPayloadBuildBusy := TRUE;

BuildTimestampUtc();

sBuildPayload := '{';
xBuildOk := TRUE;
xBuildFirstDataField := TRUE;

AddStringField(sName := 'serial', sValue := MQTT_MACHINE_SERIAL);
AddStringField(sName := 'model', sValue := 'ifm_CR1203');
AddStringField(sName := 'firmware', sValue := VersionHMI.VERSION);
AddStringField(sName := 'machineId', sValue := MQTT_MACHINE_SERIAL);
AddStringField(sName := 'deviceTwinSchemaVersion', sValue := '1.0');
AddStringField(sName := 'lastUpdated', sValue := sTimestampUtc);
Append(sText := '}');

IF xBuildOk THEN
    BuildHmiInfoPayload := EnqueueControlPayload(
        uiMessageId := uiHmiInfoMessageId,
        wsTopic := wsHmiInfoTopicName,
        xRetain := TRUE,
        sPayload := sBuildPayload
    );

    IF BuildHmiInfoPayload THEN
        MQTT_HMI_INFO_PUBLISH_ENQUEUED := MQTT_HMI_INFO_PUBLISH_ENQUEUED + 1;
    END_IF
ELSE
    udiBuildErrors := udiBuildErrors + 1;
END_IF

xPayloadBuildBusy := FALSE;