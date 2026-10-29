
(********************** Declaration ****************************)
METHOD EnqueueFakeCycleStep : BOOL
VAR_INPUT
    iStepNumber : INT;
    xCloseout : BOOL;
    rCycleElapsedSeconds : REAL;
END_VAR
VAR
    uiCycleData : UINT;
    udiCycleScrewId : UDINT;
    iCycleScrewSide : INT;
    iCycleTrussType : INT;
END_VAR
(********************** Implementation ****************************)
IF xCloseout THEN
    uiCycleData := 0;
    udiCycleScrewId := 0;
    iCycleScrewSide := 0;
    iCycleTrussType := 0;
ELSE
    uiCycleData := CYCLE_DATA;
    udiCycleScrewId := CYCLE_SCREW;
    iCycleScrewSide := CYCLE_SIDE;
    iCycleTrussType := CYCLE_TRUSS;
END_IF

EnqueueFakeCycleStep := EnqueueMessage103(
    STATE_NUMBER := iStepNumber,
    CYCLE_DATA := uiCycleData,
    CYCLE_SCREW_ID := udiCycleScrewId,
    CYCLE_SCREW_SIDE := iCycleScrewSide,
    CYCLE_TRUSS_TYPE := iCycleTrussType,
    TIME_ELAPSED := TIME_SECONDS_FLOAT,
    CYCLE_TIME_ELAPSED := rCycleElapsedSeconds
);