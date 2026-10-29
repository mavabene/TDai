
(********************** Declaration ****************************)
METHOD prepLinuxAsync
VAR_INPUT
	pASYNC: POINTER TO ifmDevice.LinuxSysCallAsync;
	pTON: POINTER TO TON;
	CMD: STRING[255];
	TIMEOUT: TIME;
END_VAR

(********************** Implementation ****************************)
	(* Prepare to start to execute the command. *)
	pASYNC^(xExecute := FALSE, sCommand := '');
	pASYNC^(xExecute := TRUE, sCommand := CMD);
	
	(* Put the falling edge for the on-delay timer used for timeout.  Make this a loooooong timeout. *)
	pTON^(IN := FALSE, PT := TIMEOUT);
