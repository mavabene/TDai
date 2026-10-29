
(********************** Declaration ****************************)
METHOD checkIntValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: INT;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO INT;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO INT;
END_VAR

(********************** Implementation ****************************)
IF VALUE_FROM_HMI <> pPERSISTENT_VALUE_ON_PLC^ THEN
	pPERSISTENT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	pTRANSMIT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	checkIntValueAndUpdate := TRUE;
ELSE
	checkIntValueAndUpdate := FALSE;
END_IF