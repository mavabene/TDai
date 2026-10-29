
(********************** Declaration ****************************)
METHOD BuildTimestampUtc : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
rtcResult := SysTimeRtcHighResGet(stUtcMs);
rtcResult := SysTimeRtcConvertHighResToDate(stUtcMs, stdUtc);
SysTimeGetUs(pUsTime := stUsNow);

udiMicro := TO_UDINT((TO_ULINT(stdUtc.wMilliseconds) * 1000) + (stUsNow MOD 1000));

sYear := TO_STRING(stdUtc.wYear);
sMonth := TO_STRING(stdUtc.wMonth);   IF stdUtc.wMonth < 10 THEN sMonth := CONCAT('0', sMonth); END_IF
sDay := TO_STRING(stdUtc.wDay);       IF stdUtc.wDay < 10 THEN sDay := CONCAT('0', sDay); END_IF
sHour := TO_STRING(stdUtc.wHour);     IF stdUtc.wHour < 10 THEN sHour := CONCAT('0', sHour); END_IF
sMinute := TO_STRING(stdUtc.wMinute); IF stdUtc.wMinute < 10 THEN sMinute := CONCAT('0', sMinute); END_IF
sSecond := TO_STRING(stdUtc.wSecond); IF stdUtc.wSecond < 10 THEN sSecond := CONCAT('0', sSecond); END_IF

sMicro := TO_STRING(udiMicro);
IF udiMicro < 10 THEN sMicro := CONCAT('00000', sMicro);
ELSIF udiMicro < 100 THEN sMicro := CONCAT('0000', sMicro);
ELSIF udiMicro < 1000 THEN sMicro := CONCAT('000', sMicro);
ELSIF udiMicro < 10000 THEN sMicro := CONCAT('00', sMicro);
ELSIF udiMicro < 100000 THEN sMicro := CONCAT('0', sMicro);
END_IF

sTimestampUtc := CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(sYear, '-'), sMonth), '-'), sDay), 'T'), sHour), ':'), sMinute), ':'), sSecond), '.'), sMicro);
sTimestampUtc := CONCAT(sTimestampUtc, 'Z');

BuildTimestampUtc := TRUE;