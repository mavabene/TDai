
(********************** Declaration ****************************)
METHOD EnqueueMessage22_AsBuiltScrew : BOOL
VAR_INPUT
    stScrew : sAsBuiltScrewEvent;
END_VAR
VAR
    sLocalScrewId : STRING(40);
END_VAR

(********************** Implementation ****************************)


sLocalScrewId := TO_STRING(stScrew.udiScrewNumber);

IF NOT StartPayload(uiMessageId := 22, sPreScrewId := sLocalScrewId) THEN
    EnqueueMessage22_AsBuiltScrew := FALSE;
    RETURN;
END_IF

AddStringField(sName := 'event_type', sValue := 'foundation_screw');
AddStringField(sName := 'PNEZD_P', sValue := stScrew.sPnezdP);
AddNumberTextField(sName := 'ScrewNumber', sValue := TO_STRING(stScrew.udiScrewNumber));
AddNumberTextField(sName := 'ScrewSide', sValue := TO_STRING(stScrew.iScrewSideCode));
AddNumberTextField(sName := 'ScrewDriveExitReason', sValue := TO_STRING(stScrew.iScrewDriveCompleteCode)); 
AddNumberTextField(sName := 'TargetEmbedment', sValue := TO_STRING(stScrew.rTargetEmbedment));
AddNumberTextField(sName := 'ActualEmbedment', sValue := TO_STRING(stScrew.rActualEmbedment));
AddNumberTextField(sName := 'HammerDistance', sValue := TO_STRING(stScrew.rHammerDistance));
AddBoolField(sName := 'IETriggered', xValue := stScrew.xIntelligentEmbedmentTriggered);
AddNumberTextField(sName := 'FinalLegLength', sValue := TO_STRING(stScrew.rFinalLegLength));
AddNumberTextField(sName := 'EmbedmentReduction', sValue := TO_STRING(stScrew.rEmbedmentReduction));
AddNumberTextField(sName := 'EmbedmentReductionStructural', sValue := TO_STRING(stScrew.rEmbedmentReductionStructural));

AddBoolField(sName := 'MastPreloadOn', xValue := stScrew.xMastPreloadOn);
AddBoolField(sName := 'AutoMastLeanCompensation', xValue := stScrew.xAutoMastLeanCompensation);

AddNumberTextField(sName := 'ClearSpoilsBitProtrusion', sValue := TO_STRING(stScrew.rClearSpoilsBitProtrusion));
AddNumberTextField(sName := 'ScrewStallPressure', sValue := TO_STRING(stScrew.rScrewStallPressure));
AddNumberTextField(sName := 'ScrewStallTime', sValue := TO_STRING(stScrew.rScrewStallTime));
AddNumberTextField(sName := 'HardSoilDetectPressure', sValue := TO_STRING(stScrew.rHardSoilDetectPressure));
AddNumberTextField(sName := 'HardSoilDetectTime', sValue := TO_STRING(stScrew.rHardSoilDetectTime));
AddNumberTextField(sName := 'MaxStallsNormal', sValue := TO_STRING(stScrew.iMaxStallsNormal));
AddNumberTextField(sName := 'MaxStallsRetracted', sValue := TO_STRING(stScrew.iMaxStallsRetracted));

AddNumberTextField(sName := 'HighestScrewDriveSpeed', sValue := TO_STRING(stScrew.rHighestScrewDriveSpeed));
AddNumberTextField(sName := 'LowControlPressure', sValue := TO_STRING(stScrew.rLowControlPressure));
AddNumberTextField(sName := 'LowestScrewSpeed', sValue := TO_STRING(stScrew.rLowestScrewSpeed));
AddNumberTextField(sName := 'HighControlPressure', sValue := TO_STRING(stScrew.rHighControlPressure));
AddBoolField(sName := 'SoftSoilEnabled', xValue := stScrew.xSoftSoilEnabled);

AddNumberTextField(sName := 'HammerControlSource', sValue := TO_STRING(stScrew.iHammerControlSource));
AddNumberTextField(sName := 'HammerOnPressure', sValue := TO_STRING(stScrew.rHammerOnPressure));
AddNumberTextField(sName := 'HammerOffPressure', sValue := TO_STRING(stScrew.rHammerOffPressure));

EnqueueMessage22_AsBuiltScrew :=
    FinishPayload(uiMessageId := 22, uiPriority := 1);