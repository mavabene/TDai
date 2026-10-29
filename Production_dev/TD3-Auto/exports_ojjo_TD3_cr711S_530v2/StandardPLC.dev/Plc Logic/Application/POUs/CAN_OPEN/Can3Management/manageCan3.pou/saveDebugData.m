
(********************** Declaration ****************************)
METHOD saveDebugData
VAR_INPUT
	pIN: POINTER TO ARRAY [1..8] OF BYTE;
	pDEBUG: POINTER TO ARRAY [1..8] OF BYTE;
END_VAR
VAR
	IDX: UINT;
END_VAR

(********************** Implementation ****************************)
FOR IDX := 1 TO 8 DO
	pDEBUG^[IDX] := pIN^[IDX];
END_FOR