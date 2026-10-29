
(********************** Declaration ****************************)
METHOD checkVectorValueAndUpdate : BOOL
VAR_INPUT
	VALUE_FROM_HMI: Vector3D;
	pPERSISTENT_VALUE_ON_PLC: POINTER TO Vector3D;
	pTRANSMIT_VALUE_ON_PLC: POINTER TO Vector3D;
END_VAR
VAR
	index: USINT;
END_VAR
(********************** Implementation ****************************)
checkVectorValueAndUpdate := FALSE;
FOR index := 1 TO 3 DO
	IF VALUE_FROM_HMI[index] <> pPERSISTENT_VALUE_ON_PLC^[index] THEN
		pPERSISTENT_VALUE_ON_PLC^[index] := VALUE_FROM_HMI[index];
		pTRANSMIT_VALUE_ON_PLC^[index] := VALUE_FROM_HMI[index];
		checkVectorValueAndUpdate := TRUE;
	END_IF
END_FOR

