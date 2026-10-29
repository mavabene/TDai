
(********************** Declaration ****************************)
METHOD handleEngineRev
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
(* Starting with TD-3.1, we can rev the engine from the remote, which allows us to pull it out of the container with
	our software installed!

	Note that there is no way to force these outputs from the UI, as this would almost certainly result in over revving.
*)
IF (pNVM3^.MACHINE_VERSION >= 1) AND
	(MACHINE_MODE = IDLE_MODE OR (MACHINE_MODE = TRACK_MODE AND MANUAL)) THEN
	IF REMOTE.RTCB1_UP THEN
		OUT_ENGINE_REV_UP(uiValue := 1);
		OUT_ENGINE_REV_DOWN(uiValue := 0);
	ELSIF REMOTE.RTCB1_DN THEN
		OUT_ENGINE_REV_UP(uiValue := 0);
		OUT_ENGINE_REV_DOWN(uiValue := 1);
	ELSE
		OUT_ENGINE_REV_UP(uiValue := 0);
		OUT_ENGINE_REV_DOWN(uiValue := 0);
	END_IF
END_IF

