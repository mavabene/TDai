
(********************** Declaration ****************************)
// this will cause an overrun error if the input is not a standard string size!!!!

METHOD checkStringValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: STRING;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO STRING;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO STRING;
END_VAR

(********************** Implementation ****************************)
IF VALUE_FROM_HMI <> pPERSISTENT_VALUE_ON_PLC^ THEN
	pPERSISTENT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	pTRANSMIT_VALUE_ON_PLC^ := VALUE_FROM_HMI;
	checkStringValueAndUpdate := TRUE;
ELSE
	checkStringValueAndUpdate := FALSE;
END_IF