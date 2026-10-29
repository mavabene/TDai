
(********************** Declaration ****************************)
METHOD AddBoolField : BOOL
VAR_INPUT
    sName : STRING(80);
    xValue : BOOL;
END_VAR

(********************** Implementation ****************************)
AddComma();
Append(sText := '$"');
Append(sText := sName);
Append(sText := '$":');

IF xValue THEN
    AddBoolField := Append(sText := 'true');
ELSE
    AddBoolField := Append(sText := 'false');
END_IF