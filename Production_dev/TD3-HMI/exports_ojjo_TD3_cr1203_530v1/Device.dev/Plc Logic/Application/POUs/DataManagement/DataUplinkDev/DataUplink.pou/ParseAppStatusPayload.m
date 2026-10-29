
(********************** Declaration ****************************)
METHOD ParseAppStatusPayload : BOOL
VAR_INPUT
    sPayload : STRING(1023);
END_VAR
(********************** Implementation ****************************)
sK410AppState := GetJsonStringField(sPayload := sPayload, sField := 'state');
sK410LastUpdatedUtc := GetJsonStringField(sPayload := sPayload, sField := 'lastUpdated');
xK410LastUpdatedParsed := FALSE;

IF (sK410AppState <> '') AND (sK410LastUpdatedUtc <> '') THEN
    IF ParseIsoUtcToHighRes(sIsoUtc := sK410LastUpdatedUtc) THEN
		stK410LastUpdatedMs := SysTimeGetMs();
//         stK410LastUpdatedMs := stParsedIsoUtcMs;
        xK410LastUpdatedParsed := TRUE;
    END_IF
END_IF

ParseAppStatusPayload := sK410AppState <> '';
UpdateK410StatusFreshness();