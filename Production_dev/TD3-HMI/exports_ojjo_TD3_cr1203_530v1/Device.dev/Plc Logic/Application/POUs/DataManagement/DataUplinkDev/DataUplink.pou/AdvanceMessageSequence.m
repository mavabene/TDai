
(********************** Declaration ****************************)
METHOD AdvanceMessageSequence : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
udiNextMessageSequence := udiNextMessageSequence + 1;
IF udiNextMessageSequence = 0 THEN
    udiNextMessageSequence := 1;
END_IF

AdvanceMessageSequence := TRUE;