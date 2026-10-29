
(********************** Declaration ****************************)
METHOD StartPayload : BOOL
VAR_INPUT
    uiMessageId : UINT;
    sPreScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)
IF NOT ENABLE_MQTT_UPLINK THEN
    udiRejectedDisabled := udiRejectedDisabled + 1;
    StartPayload := FALSE;
    RETURN;
END_IF

IF xPayloadBuildBusy THEN
    StartPayload := FALSE;
    RETURN;
END_IF

xPayloadBuildBusy := TRUE;

BuildTimestampUtc();

sBuildPayload := '';
xBuildOk := TRUE;
xBuildFirstDataField := TRUE;

sFirmware := CONCAT('hmi-fw-', VersionHMI.VERSION);
sMachineId := TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE);
udiCurrentMessageSequence := udiNextMessageSequence;
sMessageSequence := TO_STRING(udiCurrentMessageSequence);

Append(sText := '{$"timestamp_utc$":$"');
Append(sText := sTimestampUtc);
Append(sText := '$",$"schema_version$":$"1.0$",$"message_id$":');
Append(sText := TO_STRING(uiMessageId));
Append(sText := ',$"message_sequence$":');
Append(sText := sMessageSequence);
Append(sText := ',$"firmware$":$"');
Append(sText := sFirmware);
Append(sText := '$",$"data$":{');

AddStringField(sName := 'pre_Timestamp', sValue := sTimestampUtc);
AddStringField(sName := 'pre_MachineId', sValue := sMachineId);
AddStringField(sName := 'pre_ScrewID', sValue := sPreScrewId);

StartPayload := xBuildOk;

IF NOT StartPayload THEN
    xPayloadBuildBusy := FALSE;
END_IF