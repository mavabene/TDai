
(********************** Declaration ****************************)
METHOD Write : BOOL
VAR_INPUT
	FH: RTS_IEC_HANDLE;	
END_VAR

(********************** Implementation ****************************)
SysTimeGetUs(pUsTime := sys_Us_start);
BYTES_WRITTEN := SysFileWrite(
	hFile:= FH, 
	pbyBuffer:= ADR(DATA), 
	ulSize:= TO_DWORD(StrLenA(ADR(DATA))), 
	pResult:= ADR(ERROR_WRITE)
);
ERROR := ERROR OR ERROR_WRITE <> CmpErrors.Errors.ERR_OK;

SysTimeGetUs(pUsTime := sys_Us_end);
WriteTimeMS := TO_INT(sys_Us_end - sys_Us_start) / 1000.0;

(* Write time statistics. *)
WRITE_TIME_SUM := WRITE_TIME_SUM + WriteTimeMS;
WRITE_TIME_COUNT := WRITE_TIME_COUNT + 1;
WRITE_TIME_AVG := WRITE_TIME_SUM / TO_REAL(WRITE_TIME_COUNT);
IF WriteTimeMS > WRITE_TIME_MAX THEN
	WRITE_TIME_MAX := WriteTimeMS;
END_IF

