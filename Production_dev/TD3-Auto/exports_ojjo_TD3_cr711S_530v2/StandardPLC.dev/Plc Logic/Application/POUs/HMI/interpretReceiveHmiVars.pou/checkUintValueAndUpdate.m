
(********************** Declaration ****************************)
METHOD checkUintValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: UINT;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO UINT;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO UINT;
END_VAR

(********************** Implementation ****************************)
IF VALUE_FROM_HMI <> pPERSISTENT_VALUE_ON_PLC^ THEN
	pPERSISTENT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	pTRANSMIT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	checkUintValueAndUpdate := TRUE;
ELSE
	checkUintValueAndUpdate := FALSE;
END_IF