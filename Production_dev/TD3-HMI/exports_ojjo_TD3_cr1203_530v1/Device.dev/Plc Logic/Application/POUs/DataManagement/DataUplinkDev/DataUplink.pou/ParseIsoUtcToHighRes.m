
(********************** Declaration ****************************)
METHOD ParseIsoUtcToHighRes : BOOL
VAR_INPUT
    sIsoUtc : STRING(40);
END_VAR
VAR
    stdParsed : SYSTIMEDATE;
END_VAR
(********************** Implementation ****************************)
ParseIsoUtcToHighRes := FALSE;
stParsedIsoUtcMs := 0;

IF LEN(sIsoUtc) < 20 THEN
    RETURN;
END_IF

IF (MID(sIsoUtc, 1, 5) <> '-') OR
   (MID(sIsoUtc, 1, 8) <> '-') OR
   (MID(sIsoUtc, 1, 11) <> 'T') OR
   (MID(sIsoUtc, 1, 14) <> ':') OR
   (MID(sIsoUtc, 1, 17) <> ':') THEN
    RETURN;
END_IF

stdParsed.wYear := STRING_TO_UINT(MID(sIsoUtc, 4, 1));
stdParsed.wMonth := STRING_TO_UINT(MID(sIsoUtc, 2, 6));
stdParsed.wDay := STRING_TO_UINT(MID(sIsoUtc, 2, 9));
stdParsed.wHour := STRING_TO_UINT(MID(sIsoUtc, 2, 12));
stdParsed.wMinute := STRING_TO_UINT(MID(sIsoUtc, 2, 15));
stdParsed.wSecond := STRING_TO_UINT(MID(sIsoUtc, 2, 18));
stdParsed.wMilliseconds := 0;

rtcResult := SysTimeRtcConvertDateToHighRes(stdParsed, stParsedIsoUtcMs);
ParseIsoUtcToHighRes := rtcResult = 0;