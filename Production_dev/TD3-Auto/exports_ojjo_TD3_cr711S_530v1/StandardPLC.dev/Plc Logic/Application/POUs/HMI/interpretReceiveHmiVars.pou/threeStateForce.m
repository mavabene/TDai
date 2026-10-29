
(********************** Declaration ****************************)
METHOD threeStateForce : BOOL
VAR_INPUT
	STATE: DWORD;
	pFORCE1: POINTER TO sForceOutput;
	pFORCE2: POINTER TO sForceOutput;
END_VAR

(********************** Implementation ****************************)
(* I/O forcing from the HMI is only valid when the machine is in manual.  When in auto, we override the
	forces and run the machine. *)
IF NOT AUTOMATIC THEN
	CASE STATE OF
		0:
			pFORCE1^.FORCED := FALSE;
			pFORCE2^.FORCED := FALSE;
		1:
			pFORCE1^.FORCED := TRUE;
			pFORCE1^.DOUT_STATE := TRUE;
			pFORCE2^.FORCED := FALSE;
			pFORCE2^.DOUT_STATE := FALSE;
		2:
			pFORCE1^.FORCED := FALSE;
			pFORCE1^.DOUT_STATE := FALSE;
			pFORCE2^.FORCED := TRUE;
			pFORCE2^.DOUT_STATE := TRUE;
	END_CASE
ELSE
	pFORCE1^.FORCED := FALSE;
	pFORCE2^.FORCED := FALSE;
END_IF
