
(********************** Declaration ****************************)
METHOD EnqueuePayload : BOOL
VAR_INPUT
    uiMessageId : UINT;
    uiPriority : UINT;
    sPayload : STRING(4095);
END_VAR
VAR
    uiNextHead : UINT;
END_VAR
(********************** Implementation ****************************)
EnqueuePayload := FALSE;

IF NOT ENABLE_MQTT_UPLINK THEN
    udiRejectedDisabled := udiRejectedDisabled + 1;
    RETURN;
END_IF

IF uiQueueHead >= 16 THEN
    uiNextHead := 1;
ELSE
    uiNextHead := uiQueueHead + 1;
END_IF

IF uiNextHead = uiQueueTail THEN
    MQTT_QUEUE_DROPPED := MQTT_QUEUE_DROPPED + 1;
    udiRejectedQueueFull := udiRejectedQueueFull + 1;

    IF uiPriority > 1 THEN
        MQTT_QUEUE_DROPPED_LOW_PRIORITY := MQTT_QUEUE_DROPPED_LOW_PRIORITY + 1;
    END_IF

    RETURN;
END_IF

aQueue[uiQueueHead].STATE := MQTT_SLOT_WRITING;
aQueue[uiQueueHead].MESSAGE_ID := uiMessageId;
aQueue[uiQueueHead].PRIORITY := uiPriority;
aQueue[uiQueueHead].TOPIC_NAME := wsTelemetryTopicName;
aQueue[uiQueueHead].RETAIN_MSG := FALSE;
aQueue[uiQueueHead].CONTROL := FALSE;
aQueue[uiQueueHead].PAYLOAD := sPayload;
aQueue[uiQueueHead].PAYLOAD_SIZE := DINT_TO_UDINT(Stu.StrLenA(ADR(aQueue[uiQueueHead].PAYLOAD)));
aQueue[uiQueueHead].STATE := MQTT_SLOT_READY;

uiQueueHead := uiNextHead;

MQTT_QUEUE_ENQUEUED := MQTT_QUEUE_ENQUEUED + 1;
EnqueuePayload := TRUE;