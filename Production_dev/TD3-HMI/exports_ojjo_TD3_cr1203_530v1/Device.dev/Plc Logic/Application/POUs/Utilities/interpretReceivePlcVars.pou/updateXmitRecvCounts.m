
(********************** Declaration ****************************)
METHOD updateXmitRecvCounts : BOOL
VAR_INPUT
	pXMIT_COUNT: POINTER TO DWORD;
	pXMIT_COUNT_LAST: POINTER TO DWORD;
	pRECV_COUNT: POINTER TO DWORD;
	pRECV_COUNT_LAST: POINTER TO DWORD;
	pRECV_INTERVAL: POINTER TO DWORD;
END_VAR

(********************** Implementation ****************************)
IF pXMIT_COUNT^ <> pXMIT_COUNT_LAST^ THEN
	pRECV_INTERVAL^ := pXMIT_COUNT^ - pXMIT_COUNT_LAST^;
	pXMIT_COUNT_LAST^ := pXMIT_COUNT^;
	pRECV_COUNT^ := pRECV_COUNT^ + 1;
END_IF
