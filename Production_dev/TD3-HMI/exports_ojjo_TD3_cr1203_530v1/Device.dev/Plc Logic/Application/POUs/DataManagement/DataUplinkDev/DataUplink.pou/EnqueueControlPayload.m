
(********************** Declaration ****************************)
METHOD EnqueueControlPayload : BOOL
VAR_INPUT
    uiMessageId : UINT;
    wsTopic : WSTRING(80);
    xRetain : BOOL;
    sPayload : STRING(4095);
END_VAR
VAR
    uiNextHead : UINT;
END_VAR
(********************** Implementation ****************************)
EnqueueControlPayload := FALSE;

IF NOT ENABLE_MQTT_UPLINK THEN
    udiRejectedDisabled := udiRejectedDisabled + 1;
    RETURN;
END_IF

IF uiControlQueueHead >= 4 THEN
    uiNextHead := 1;
ELSE
    uiNextHead := uiControlQueueHead + 1;
END_IF

IF uiNextHead = uiControlQueueTail THEN
    MQTT_CONTROL_QUEUE_DROPPED := MQTT_CONTROL_QUEUE_DROPPED + 1;
    udiRejectedControlQueueFull := udiRejectedControlQueueFull + 1;
    RETURN;
END_IF

aControlQueue[uiControlQueueHead].STATE := MQTT_SLOT_WRITING;
aControlQueue[uiControlQueueHead].MESSAGE_ID := uiMessageId;
aControlQueue[uiControlQueueHead].PRIORITY := 0;
aControlQueue[uiControlQueueHead].TOPIC_NAME := wsTopic;
aControlQueue[uiControlQueueHead].RETAIN_MSG := xRetain;
aControlQueue[uiControlQueueHead].CONTROL := TRUE;
aControlQueue[uiControlQueueHead].PAYLOAD := sPayload;
aControlQueue[uiControlQueueHead].PAYLOAD_SIZE := DINT_TO_UDINT(Stu.StrLenA(ADR(aControlQueue[uiControlQueueHead].PAYLOAD)));
aControlQueue[uiControlQueueHead].STATE := MQTT_SLOT_READY;

uiControlQueueHead := uiNextHead;
EnqueueControlPayload := TRUE;