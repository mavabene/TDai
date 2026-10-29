
(********************** Declaration ****************************)
METHOD Append : BOOL
VAR_INPUT
    sText : STRING(4095);
END_VAR

(********************** Implementation ****************************)
Append := Stu.StrConcatA(ADR(sText), ADR(sBuildPayload), TO_INT(SIZEOF(sBuildPayload)));
xBuildOk := xBuildOk AND Append;