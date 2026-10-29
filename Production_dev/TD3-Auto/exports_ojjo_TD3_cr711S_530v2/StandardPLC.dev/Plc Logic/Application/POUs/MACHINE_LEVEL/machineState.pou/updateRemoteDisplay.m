
(********************** Declaration ****************************)
METHOD updateRemoteDisplay
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF AUTOMATIC THEN
	METHOD_STRING := 'Automatic';
ELSE
	METHOD_STRING := 'Manual';
END_IF

IF ESTOP_CURRENT <> 0 THEN
	ERROR_STRING_SHORT := 'See HMI!!!';
ELSE
	ERROR_STRING_SHORT := '';
END_IF

IF WARNING_CURRENT <> 0 THEN
	WARNING_STRING_SHORT := 'See HMI!!!';
ELSE
	WARNING_STRING_SHORT := '';
END_IF