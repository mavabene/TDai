
(********************** Declaration ****************************)
METHOD FinishPayload : BOOL
VAR_INPUT
    uiMessageId : UINT;
    uiPriority : UINT;
END_VAR

(********************** Implementation ****************************)
Append(sText := '}}');

IF xBuildOk THEN
    FinishPayload := EnqueuePayload(
        uiMessageId := uiMessageId,
        uiPriority := uiPriority,
        sPayload := sBuildPayload
    );

    IF FinishPayload THEN
        AdvanceMessageSequence();
    END_IF
ELSE
    udiBuildErrors := udiBuildErrors + 1;
    FinishPayload := FALSE;
END_IF

xPayloadBuildBusy := FALSE;