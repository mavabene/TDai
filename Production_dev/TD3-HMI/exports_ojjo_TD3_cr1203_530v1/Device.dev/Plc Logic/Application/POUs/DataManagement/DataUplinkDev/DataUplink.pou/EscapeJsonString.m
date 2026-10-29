
(********************** Declaration ****************************)
METHOD EscapeJsonString : STRING(1023)
VAR_INPUT
    sValue : STRING(255);
END_VAR
VAR
    i : INT;
    iLen : INT;
    sChar : STRING(1);
    xOk : BOOL;
END_VAR
(********************** Implementation ****************************)
EscapeJsonString := '';
iLen := LEN(sValue);

FOR i := 1 TO iLen DO
    sChar := MID(sValue, 1, i);

    IF sChar = '$"' THEN
        xOk := Stu.StrConcatA(ADR('\$"'), ADR(EscapeJsonString), TO_INT(SIZEOF(EscapeJsonString)));
    ELSIF sChar = '\' THEN
        xOk := Stu.StrConcatA(ADR('\\'), ADR(EscapeJsonString), TO_INT(SIZEOF(EscapeJsonString)));
    ELSIF sChar = '$R' THEN
        xOk := Stu.StrConcatA(ADR('\r'), ADR(EscapeJsonString), TO_INT(SIZEOF(EscapeJsonString)));
    ELSIF sChar = '$N' THEN
        xOk := Stu.StrConcatA(ADR('\n'), ADR(EscapeJsonString), TO_INT(SIZEOF(EscapeJsonString)));
    ELSIF sChar = '$T' THEN
        xOk := Stu.StrConcatA(ADR('\t'), ADR(EscapeJsonString), TO_INT(SIZEOF(EscapeJsonString)));
    ELSE
        xOk := Stu.StrConcatA(ADR(sChar), ADR(EscapeJsonString), TO_INT(SIZEOF(EscapeJsonString)));
    END_IF

    IF NOT xOk THEN
        xBuildOk := FALSE;
        RETURN;
    END_IF
END_FOR