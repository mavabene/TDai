
(********************** Declaration ****************************)
METHOD twoStateForce : BOOL
VAR_INPUT
	STATE: DWORD;
	pFORCE: POINTER TO sForceOutput;
END_VAR

(********************** Implementation ****************************)
(* I/O forcing from the HMI is only valid when the machine is in manual.  When in auto, we override the
	forces and run the machine. *)
IF NOT AUTOMATIC THEN
	CASE STATE OF
		0:
			pFORCE^.FORCED := FALSE;
		1:
			pFORCE^.FORCED := TRUE;
			pFORCE^.DOUT_STATE := TRUE;
		2:
			pFORCE^.FORCED := TRUE;
			pFORCE^.DOUT_STATE := FALSE;
	END_CASE
ELSE
	pFORCE^.FORCED := FALSE;
END_IF
