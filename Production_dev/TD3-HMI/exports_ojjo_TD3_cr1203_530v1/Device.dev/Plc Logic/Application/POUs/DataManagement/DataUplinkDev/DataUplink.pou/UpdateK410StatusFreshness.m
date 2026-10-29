
(********************** Declaration ****************************)
METHOD UpdateK410StatusFreshness : BOOL
VAR_INPUT
END_VAR
VAR
	CURRENT_MS: DWORD;
END_VAR

(********************** Implementation ****************************)
IF xK410LastUpdatedParsed THEN
    rtcResult := SysTimeRtcHighResGet(stUtcMs);
	CURRENT_MS := SysTimeCore.SysTimeGetMs();

    IF CURRENT_MS >= stK410LastUpdatedMs THEN
        udiK410AppStatusAgeMs := TO_UDINT(CURRENT_MS - stK410LastUpdatedMs);
    ELSE
        udiK410AppStatusAgeMs := 0;
    END_IF

    xK410AppStatusFresh := udiK410AppStatusAgeMs <= 15000;
ELSE
    udiK410AppStatusAgeMs := 0;
    xK410AppStatusFresh := FALSE;
END_IF

xK410ReadyToPublish := xK410AppStatusFresh AND ((sK410AppState = 'ready') OR (sK410AppState = 'degraded'));

MQTT_APP_STATUS_STATE := sK410AppState;
MQTT_APP_STATUS_LAST_UPDATED := sK410LastUpdatedUtc;
MQTT_APP_STATUS_AGE_MS := udiK410AppStatusAgeMs;
MQTT_APP_STATUS_STALE := NOT xK410AppStatusFresh;
MQTT_K410_READY_TO_PUBLISH := xK410ReadyToPublish;

IF xK410AppStatusFresh AND (sK410AppState = 'ready') THEN
    MQTT_APP_STATUS_COLOR := colorGreen(16#FF);
ELSIF xK410AppStatusFresh AND ((sK410AppState = 'starting') OR (sK410AppState = 'degraded') OR (sK410AppState = 'stopping')) THEN
    MQTT_APP_STATUS_COLOR := colorYellow(16#FF);
ELSE
    MQTT_APP_STATUS_COLOR := colorRed(16#FF);
END_IF

UpdateK410StatusFreshness := xK410ReadyToPublish;