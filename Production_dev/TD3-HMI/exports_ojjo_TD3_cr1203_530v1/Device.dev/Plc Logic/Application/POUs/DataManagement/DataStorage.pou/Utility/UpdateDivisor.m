
(********************** Declaration ****************************)
METHOD UpdateDivisor : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
DATA_ACQ_FREQ_DIVISOR := 1;
RETURN;

(*
CASE SET_DATA_ACQ_FREQ_SELECT_VALUE OF
	1:
		// 2 Hz
		DATA_ACQ_FREQ_DIVISOR := 5; 
	2:
		// 5 Hz
		DATA_ACQ_FREQ_DIVISOR := 2; 
	3:
		// 10 Hz
		DATA_ACQ_FREQ_DIVISOR := 1; 
	ELSE
		// 1 Hz, default
		DATA_ACQ_FREQ_DIVISOR := 10; 
END_CASE
*)
