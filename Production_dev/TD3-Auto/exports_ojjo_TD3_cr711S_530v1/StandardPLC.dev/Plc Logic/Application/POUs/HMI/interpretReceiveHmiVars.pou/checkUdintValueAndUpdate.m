
(********************** Declaration ****************************)
METHOD checkUdintValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: UDINT;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO UDINT;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO UDINT;
END_VAR

(********************** Implementation ****************************)
IF VALUE_FROM_HMI <> pPERSISTENT_VALUE_ON_PLC^ THEN
	pPERSISTENT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	pTRANSMIT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	checkUdintValueAndUpdate := TRUE;
ELSE
	checkUdintValueAndUpdate := FALSE;
END_IF