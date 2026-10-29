
(********************** Declaration ****************************)
METHOD checkSintValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: SINT;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO SINT;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO SINT;
END_VAR

(********************** Implementation ****************************)
IF VALUE_FROM_HMI <> pPERSISTENT_VALUE_ON_PLC^ THEN
	pPERSISTENT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	pTRANSMIT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	checkSintValueAndUpdate := TRUE;
ELSE
	checkSintValueAndUpdate := FALSE;
END_IF