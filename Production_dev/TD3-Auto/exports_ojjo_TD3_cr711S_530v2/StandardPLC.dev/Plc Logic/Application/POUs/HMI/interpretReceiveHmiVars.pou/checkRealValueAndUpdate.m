
(********************** Declaration ****************************)
METHOD checkRealValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: REAL;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO REAL;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO REAL;
END_VAR

(********************** Implementation ****************************)
IF VALUE_FROM_HMI <> pPERSISTENT_VALUE_ON_PLC^ THEN
	pPERSISTENT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	pTRANSMIT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	checkRealValueAndUpdate := TRUE;
ELSE
	checkRealValueAndUpdate := FALSE;
END_IF