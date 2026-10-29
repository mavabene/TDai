
(********************** Declaration ****************************)
METHOD AddComma : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF NOT xBuildFirstDataField THEN
    AddComma := Append(sText := ',');
ELSE
    AddComma := TRUE;
    xBuildFirstDataField := FALSE;
END_IF