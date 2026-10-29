
(********************** Declaration ****************************)
METHOD GetJsonStringField : STRING(255)
VAR_INPUT
    sPayload : STRING(1023);
    sField : STRING(80);
END_VAR
VAR
    sFieldNeedle : STRING(100);
    iPayloadLen : INT;
    iField : INT;
    i : INT;
    iValueStart : INT;
END_VAR
(********************** Implementation ****************************)
GetJsonStringField := '';
sFieldNeedle := CONCAT('$"', sField);
sFieldNeedle := CONCAT(sFieldNeedle, '$"');
iPayloadLen := LEN(sPayload);
iField := FIND(sPayload, sFieldNeedle);

IF iField <= 0 THEN
    RETURN;
END_IF

i := iField + LEN(sFieldNeedle);

WHILE (i <= iPayloadLen) AND (MID(sPayload, 1, i) <> ':') DO
    i := i + 1;
END_WHILE

IF i > iPayloadLen THEN
    RETURN;
END_IF

i := i + 1;

WHILE (i <= iPayloadLen) AND (MID(sPayload, 1, i) <> '$"') DO
    i := i + 1;
END_WHILE

IF i > iPayloadLen THEN
    RETURN;
END_IF

i := i + 1;
iValueStart := i;

WHILE (i <= iPayloadLen) AND (MID(sPayload, 1, i) <> '$"') DO
    i := i + 1;
END_WHILE

IF i > iPayloadLen THEN
    RETURN;
END_IF

IF i > iValueStart THEN
    GetJsonStringField := MID(sPayload, i - iValueStart, iValueStart);
END_IF