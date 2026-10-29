
(********************** Declaration ****************************)
METHOD RunFakeSequence : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
RunFakeSequence := FALSE;

fbFakeStart(CLK := MQTT_FAKE_SEQUENCE_START);

IF MQTT_FAKE_SEQUENCE_START THEN
    MQTT_FAKE_SEQUENCE_START := FALSE;
END_IF

IF NOT ENABLE_MQTT_UPLINK OR NOT xTelemetryPublishAllowed THEN
    eFakeSequenceState := MQTT_FAKE_STATE_IDLE;
END_IF

CASE eFakeSequenceState OF

    MQTT_FAKE_STATE_IDLE:
        fbFakeStepDelay(IN := FALSE, PT := T#5S);
        fbFakeScrewDuration(IN := FALSE, PT := T#20S);
        fbFakeScrewSampleDelay(IN := FALSE, PT := T#100MS);

        IF fbFakeStart.Q AND ENABLE_MQTT_UPLINK AND xTelemetryPublishAllowed THEN
            udiFakeScrewSamplesSent := 0;
            uiFakeGpsSampleCount := 0;
            rFakeCycleElapsedSeconds := 0.0;
            rFakeScrewStartSeconds := 0.0;
			
			uiFakeAsBuiltJsonCount := 0;
			aFakeAsBuiltJson[1] := '';
			aFakeAsBuiltJson[2] := '';
			aFakeAsBuiltJson[3] := '';
			aFakeAsBuiltJson[4] := '';
			aFakeAsBuiltJson[5] := '';
			
			(* Shared P value ties all five test records together. *)
			stFakeAsBuiltScrew.sPnezdP := 'FAKE_AB_0001';
			stFakeAsBuiltScrew.udiScrewNumber := 90001;
			stFakeAsBuiltScrew.iScrewSideCode := 1;
			stFakeAsBuiltScrew.iScrewDriveCompleteCode := eDataCollection.SCREW_DRIVE_ENDED_NORMALLY;
			stFakeAsBuiltScrew.rTargetEmbedment := 85.0;
			stFakeAsBuiltScrew.rActualEmbedment := 84.5;
			stFakeAsBuiltScrew.rHammerDistance := 3.25;
			stFakeAsBuiltScrew.xIntelligentEmbedmentTriggered := TRUE;
			stFakeAsBuiltScrew.rFinalLegLength := 86.5;
			stFakeAsBuiltScrew.rEmbedmentReduction := 0.5;
			stFakeAsBuiltScrew.rEmbedmentReductionStructural := 0.25;
			stFakeAsBuiltScrew.xMastPreloadOn := TRUE;
			stFakeAsBuiltScrew.xAutoMastLeanCompensation := FALSE;
			stFakeAsBuiltScrew.rClearSpoilsBitProtrusion := 5.0;
			stFakeAsBuiltScrew.rScrewStallPressure := 190.0;
			stFakeAsBuiltScrew.rScrewStallTime := 1.5;
			stFakeAsBuiltScrew.rHardSoilDetectPressure := 220.0;
			stFakeAsBuiltScrew.rHardSoilDetectTime := 2.5;
			stFakeAsBuiltScrew.iMaxStallsNormal := 3;
			stFakeAsBuiltScrew.iMaxStallsRetracted := 2;
			stFakeAsBuiltScrew.rHighestScrewDriveSpeed := 120.0;
			stFakeAsBuiltScrew.rLowControlPressure := 90.0;
			stFakeAsBuiltScrew.rLowestScrewSpeed := 35.0;
			stFakeAsBuiltScrew.rHighControlPressure := 170.0;
			stFakeAsBuiltScrew.xSoftSoilEnabled := TRUE;
			stFakeAsBuiltScrew.iHammerControlSource := 1;
			stFakeAsBuiltScrew.rHammerOnPressure := 95.0;
			stFakeAsBuiltScrew.rHammerOffPressure := 80.0;
			
			stFakeAsBuiltFoundation.sPnezdP := 'FAKE_AB_0001';
			stFakeAsBuiltFoundation.iEventType := eDataCollection.TA_COLLECT_TRACK_TO_RWP;
			stFakeAsBuiltFoundation.rLatitude := 35.123450;
			stFakeAsBuiltFoundation.rLongitude := -111.654320;
			stFakeAsBuiltFoundation.rXOffset := 1.20;
			stFakeAsBuiltFoundation.rYOffset := -0.30;
			stFakeAsBuiltFoundation.rZOffset := 0.08;
			stFakeAsBuiltFoundation.rYawOffset := 0.40;
			stFakeAsBuiltFoundation.rPnezdNorthing := 3888000.0;
			stFakeAsBuiltFoundation.rPnezdEasting := 439000.0;
			stFakeAsBuiltFoundation.rPnezdHeight := 1450.0;
			stFakeAsBuiltFoundation.sPnezdDescription := 'FAKE_ASBUILT_TEST';
			stFakeAsBuiltFoundation.xRtkFixed := TRUE;
			stFakeAsBuiltFoundation.usiRadioSignalDelay := 80;
			stFakeAsBuiltFoundation.iHrms := 10;
			stFakeAsBuiltFoundation.iVrms := 15;
			stFakeAsBuiltFoundation.rPdop := 1.2;
			stFakeAsBuiltFoundation.usiSatelliteCount := 24;
			stFakeAsBuiltFoundation.rMastRoll := -1.25;
			stFakeAsBuiltFoundation.rCorrectedMastPitch := 2.50;
			stFakeAsBuiltFoundation.rGpsYaw := 90.0;
			stFakeAsBuiltFoundation.uiTotalCycleTime := 65;
			stFakeAsBuiltFoundation.usiTrackAssistStatus := eDataCollection.TA_USED_TO_END_OF_TRACK;
			stFakeAsBuiltFoundation.rFinalXSlidePosition := 5.5;
			stFakeAsBuiltFoundation.rFinalBoomSwingPosition := 3.25;
			stFakeAsBuiltFoundation.rFinalYawPosition := -12.5;
			stFakeAsBuiltFoundation.rFinalZSlidePosition := 45.0;
			
			eFakeSequenceState := MQTT_FAKE_STATE_ASBUILT_SCREW_1;
        END_IF
	
	MQTT_FAKE_STATE_ASBUILT_SCREW_1:
        IF EnqueueMessage22_AsBuiltScrew(
            stScrew := stFakeAsBuiltScrew
        ) THEN
            uiFakeAsBuiltJsonCount := uiFakeAsBuiltJsonCount + 1;
            aFakeAsBuiltJson[uiFakeAsBuiltJsonCount] := sBuildPayload;

            (* Second screw, same test foundation P value. *)
            stFakeAsBuiltScrew.udiScrewNumber := 90002;
            stFakeAsBuiltScrew.iScrewSideCode := 2;
            stFakeAsBuiltScrew.rTargetEmbedment := 110.0;
            stFakeAsBuiltScrew.rActualEmbedment := 109.6;
            stFakeAsBuiltScrew.rHammerDistance := 7.5;
            stFakeAsBuiltScrew.xIntelligentEmbedmentTriggered := FALSE;
            stFakeAsBuiltScrew.rFinalLegLength := 110.0;
            stFakeAsBuiltScrew.rEmbedmentReduction := 0.4;
            stFakeAsBuiltScrew.rEmbedmentReductionStructural := 0.2;
            stFakeAsBuiltScrew.xMastPreloadOn := FALSE;
            stFakeAsBuiltScrew.xAutoMastLeanCompensation := TRUE;

            eFakeSequenceState := MQTT_FAKE_STATE_ASBUILT_SCREW_2;
        END_IF

    MQTT_FAKE_STATE_ASBUILT_SCREW_2:
        IF EnqueueMessage22_AsBuiltScrew(
            stScrew := stFakeAsBuiltScrew
        ) THEN
            uiFakeAsBuiltJsonCount := uiFakeAsBuiltJsonCount + 1;
            aFakeAsBuiltJson[uiFakeAsBuiltJsonCount] := sBuildPayload;

            eFakeSequenceState :=
                MQTT_FAKE_STATE_ASBUILT_TRACK_LOCATING;
        END_IF

    MQTT_FAKE_STATE_ASBUILT_TRACK_LOCATING:
        IF EnqueueMessage21_AsBuiltLocating(
            stFoundation := stFakeAsBuiltFoundation
        ) THEN
            uiFakeAsBuiltJsonCount := uiFakeAsBuiltJsonCount + 1;
            aFakeAsBuiltJson[uiFakeAsBuiltJsonCount] := sBuildPayload;

            stFakeAsBuiltFoundation.iEventType :=
                eDataCollection.TA_COLLECT_RWP_TO_SCREW;
            stFakeAsBuiltFoundation.rLatitude := 35.123456;
            stFakeAsBuiltFoundation.rLongitude := -111.654315;
            stFakeAsBuiltFoundation.rXOffset := 0.50;
            stFakeAsBuiltFoundation.rYOffset := -0.15;
            stFakeAsBuiltFoundation.rZOffset := 0.05;
            stFakeAsBuiltFoundation.rYawOffset := 0.20;

            eFakeSequenceState :=
                MQTT_FAKE_STATE_ASBUILT_RWP_LOCATING;
        END_IF

    MQTT_FAKE_STATE_ASBUILT_RWP_LOCATING:
        IF EnqueueMessage21_AsBuiltLocating(
            stFoundation := stFakeAsBuiltFoundation
        ) THEN
            uiFakeAsBuiltJsonCount := uiFakeAsBuiltJsonCount + 1;
            aFakeAsBuiltJson[uiFakeAsBuiltJsonCount] := sBuildPayload;

            stFakeAsBuiltFoundation.iEventType :=
                eDataCollection.AB_COLLECT_CRIMP;
            stFakeAsBuiltFoundation.rLatitude := 35.123460;
            stFakeAsBuiltFoundation.rLongitude := -111.654310;
            stFakeAsBuiltFoundation.rXOffset := 0.10;
            stFakeAsBuiltFoundation.rYOffset := -0.05;
            stFakeAsBuiltFoundation.rZOffset := 0.02;
            stFakeAsBuiltFoundation.rYawOffset := 0.10;

            eFakeSequenceState :=
                MQTT_FAKE_STATE_ASBUILT_FOUNDATION;
        END_IF

    MQTT_FAKE_STATE_ASBUILT_FOUNDATION:
        IF EnqueueMessage21_AsBuiltLocating(
            stFoundation := stFakeAsBuiltFoundation
        ) THEN
            uiFakeAsBuiltJsonCount := uiFakeAsBuiltJsonCount + 1;
            aFakeAsBuiltJson[uiFakeAsBuiltJsonCount] := sBuildPayload;

            (* Continue the existing fake sequence unchanged. *)
            eFakeSequenceState := MQTT_FAKE_STATE_HEADER;
        END_IF

    MQTT_FAKE_STATE_HEADER:
        IF EnqueueMessage102(TIME_ELAPSED := TIME_SECONDS_FLOAT) THEN
            rFakeCycleElapsedSeconds := 0.0;
            eFakeSequenceState := MQTT_FAKE_STATE_STEP_1;
        END_IF

    MQTT_FAKE_STATE_STEP_1:
        IF EnqueueFakeCycleStep(
            iStepNumber := 1,
            xCloseout := FALSE,
            rCycleElapsedSeconds := rFakeCycleElapsedSeconds
        ) THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            eFakeSequenceState := MQTT_FAKE_STATE_WAIT_STEP_2;
        END_IF

    MQTT_FAKE_STATE_WAIT_STEP_2:
        fbFakeStepDelay(IN := TRUE, PT := T#5S);
        IF fbFakeStepDelay.Q THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            rFakeCycleElapsedSeconds := 5.0;
            eFakeSequenceState := MQTT_FAKE_STATE_STEP_2;
        END_IF

    MQTT_FAKE_STATE_STEP_2:
        IF EnqueueFakeCycleStep(
            iStepNumber := 2,
            xCloseout := FALSE,
            rCycleElapsedSeconds := rFakeCycleElapsedSeconds
        ) THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            eFakeSequenceState := MQTT_FAKE_STATE_WAIT_STEP_3;
        END_IF

    MQTT_FAKE_STATE_WAIT_STEP_3:
        fbFakeStepDelay(IN := TRUE, PT := T#5S);
        IF fbFakeStepDelay.Q THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            rFakeCycleElapsedSeconds := 10.0;
            eFakeSequenceState := MQTT_FAKE_STATE_STEP_3;
        END_IF

    MQTT_FAKE_STATE_STEP_3:
        IF EnqueueFakeCycleStep(
            iStepNumber := 3,
            xCloseout := FALSE,
            rCycleElapsedSeconds := rFakeCycleElapsedSeconds
        ) THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            eFakeSequenceState := MQTT_FAKE_STATE_WAIT_STEP_4;
        END_IF

    MQTT_FAKE_STATE_WAIT_STEP_4:
        fbFakeStepDelay(IN := TRUE, PT := T#5S);
        IF fbFakeStepDelay.Q THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            rFakeCycleElapsedSeconds := 15.0;
            eFakeSequenceState := MQTT_FAKE_STATE_STEP_4;
        END_IF

    MQTT_FAKE_STATE_STEP_4:
        IF EnqueueFakeCycleStep(
            iStepNumber := 4,
            xCloseout := FALSE,
            rCycleElapsedSeconds := rFakeCycleElapsedSeconds
        ) THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            eFakeSequenceState := MQTT_FAKE_STATE_WAIT_STEP_12;
        END_IF

    MQTT_FAKE_STATE_WAIT_STEP_12:
        fbFakeStepDelay(IN := TRUE, PT := T#5S);
        IF fbFakeStepDelay.Q THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            rFakeCycleElapsedSeconds := 20.0;
            eFakeSequenceState := MQTT_FAKE_STATE_STEP_12;
        END_IF

    MQTT_FAKE_STATE_STEP_12:
        IF EnqueueFakeCycleStep(
            iStepNumber := 12,
            xCloseout := FALSE,
            rCycleElapsedSeconds := rFakeCycleElapsedSeconds
        ) THEN
            eFakeSequenceState := MQTT_FAKE_STATE_SCREW_MESSAGE_2;
        END_IF

    MQTT_FAKE_STATE_SCREW_MESSAGE_2:
        IF EnqueueMessage2() THEN
            eFakeSequenceState := MQTT_FAKE_STATE_SCREW_MESSAGE_10;
        END_IF

    MQTT_FAKE_STATE_SCREW_MESSAGE_10:
        IF EnqueueMessage10() THEN
            eFakeSequenceState := MQTT_FAKE_STATE_SCREW_MESSAGE_20;
        END_IF

    MQTT_FAKE_STATE_SCREW_MESSAGE_20:
        IF EnqueueMessage20() THEN
            eFakeSequenceState := MQTT_FAKE_STATE_SCREW_STREAM_START;
        END_IF

    MQTT_FAKE_STATE_SCREW_STREAM_START:
        fbFakeScrewDuration(IN := FALSE, PT := T#20S);
        fbFakeScrewSampleDelay(IN := FALSE, PT := T#100MS);
        udiFakeScrewSamplesSent := 0;
        uiFakeGpsSampleCount := 0;
        rFakeScrewStartSeconds := TIME_SECONDS_FLOAT;
        eFakeSequenceState := MQTT_FAKE_STATE_SCREW_STREAMING;
		rFakeDriveTimeSeconds := 0.0;

    MQTT_FAKE_STATE_SCREW_STREAMING:
        fbFakeScrewDuration(IN := TRUE, PT := T#20S);
        fbFakeScrewSampleDelay(IN := TRUE, PT := T#100MS);

        IF fbFakeScrewSampleDelay.Q THEN
            fbFakeScrewSampleDelay(IN := FALSE, PT := T#100MS);

            rFakeDriveTimeSeconds := rFakeDriveTimeSeconds + 0.1;
			IF rFakeDriveTimeSeconds > 20.0 THEN
				rFakeDriveTimeSeconds := 20.0;
			END_IF
			
			IF EnqueueFakeMessage11(DRIVE_TIME := rFakeDriveTimeSeconds) THEN
				udiFakeScrewSamplesSent := udiFakeScrewSamplesSent + 1;
			END_IF

            uiFakeGpsSampleCount := uiFakeGpsSampleCount + 1;
            IF uiFakeGpsSampleCount >= 30 THEN
                uiFakeGpsSampleCount := 0;
                EnqueueMessage14(TIME_SINCE_MACHINE_POWER_ON := TIME_SECONDS_FLOAT - rFakeScrewStartSeconds);
            END_IF
        END_IF

        IF fbFakeScrewDuration.Q THEN
            fbFakeScrewDuration(IN := FALSE, PT := T#20S);
            fbFakeScrewSampleDelay(IN := FALSE, PT := T#100MS);
            rFakeCycleElapsedSeconds := 40.0;
            eFakeSequenceState := MQTT_FAKE_STATE_SCREW_FINISH;
        END_IF

    MQTT_FAKE_STATE_SCREW_FINISH:
        IF EnqueueMessage12() THEN
            eFakeSequenceState := MQTT_FAKE_STATE_STEP_16;
        END_IF

    MQTT_FAKE_STATE_STEP_16:
        IF EnqueueFakeCycleStep(
            iStepNumber := 16,
            xCloseout := FALSE,
            rCycleElapsedSeconds := rFakeCycleElapsedSeconds
        ) THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            eFakeSequenceState := MQTT_FAKE_STATE_WAIT_STEP_0;
        END_IF

    MQTT_FAKE_STATE_WAIT_STEP_0:
        fbFakeStepDelay(IN := TRUE, PT := T#5S);
        IF fbFakeStepDelay.Q THEN
            fbFakeStepDelay(IN := FALSE, PT := T#5S);
            rFakeCycleElapsedSeconds := 45.0;
            eFakeSequenceState := MQTT_FAKE_STATE_STEP_0;
        END_IF

    MQTT_FAKE_STATE_STEP_0:
        IF EnqueueFakeCycleStep(
            iStepNumber := 0,
            xCloseout := TRUE,
            rCycleElapsedSeconds := rFakeCycleElapsedSeconds
        ) THEN
            eFakeSequenceState := MQTT_FAKE_STATE_IDLE;
        END_IF
END_CASE

MQTT_FAKE_SEQUENCE_ACTIVE := eFakeSequenceState <> MQTT_FAKE_STATE_IDLE;
MQTT_FAKE_SEQUENCE_PHASE := TO_INT(eFakeSequenceState);
MQTT_FAKE_SEQUENCE_SAMPLES_SENT := udiFakeScrewSamplesSent;

RunFakeSequence := MQTT_FAKE_SEQUENCE_ACTIVE;