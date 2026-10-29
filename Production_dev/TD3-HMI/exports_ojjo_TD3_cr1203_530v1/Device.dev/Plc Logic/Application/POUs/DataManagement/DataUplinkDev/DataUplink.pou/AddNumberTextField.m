
(********************** Declaration ****************************)
METHOD AddNumberTextField : BOOL
VAR_INPUT
    sName : STRING(80);
    sValue : STRING(255);
END_VAR

(********************** Implementation ****************************)
AddComma();
Append(sText := '$"');
Append(sText := sName);
Append(sText := '$":');
AddNumberTextField := Append(sText := sValue);