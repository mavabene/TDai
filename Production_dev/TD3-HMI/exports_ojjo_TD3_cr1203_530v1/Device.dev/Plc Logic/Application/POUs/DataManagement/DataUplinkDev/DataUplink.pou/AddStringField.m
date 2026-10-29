
(********************** Declaration ****************************)
METHOD AddStringField : BOOL
VAR_INPUT
    sName : STRING(80);
    sValue : STRING(255);
END_VAR
VAR
    sEscapedValue : STRING(1023);
END_VAR
(********************** Implementation ****************************)
sEscapedValue := EscapeJsonString(sValue := sValue);

AddComma();
Append(sText := '$"');
Append(sText := sName);
Append(sText := '$":$"');
Append(sText := sEscapedValue);
AddStringField := Append(sText := '$"');