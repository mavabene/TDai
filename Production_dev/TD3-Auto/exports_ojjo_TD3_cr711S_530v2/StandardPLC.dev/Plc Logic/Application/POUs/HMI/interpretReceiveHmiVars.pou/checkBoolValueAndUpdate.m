
(********************** Declaration ****************************)
METHOD checkBoolValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: BOOL;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO BOOL;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO BOOL;
END_VAR

(********************** Implementation ****************************)
IF VALUE_FROM_HMI <> pPERSISTENT_VALUE_ON_PLC^ THEN
	pPERSISTENT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	pTRANSMIT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	checkBoolValueAndUpdate := TRUE;
ELSE
	checkBoolValueAndUpdate := FALSE;
END_IF