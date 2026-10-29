
(********************** Declaration ****************************)
METHOD initializeNVM
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
IF pNVM1^.NVM1_NEEDS_INIT <> DEFAULTS1.NVM1_NEEDS_INIT THEN
	SysMemCpy(pNVM1, ADR(DEFAULTS1), SIZEOF(sPersistent_1));
	RESET_NVM1 := TRUE;
END_IF

(* Managing the persistent storage area by hand here. *)
pNVM2 := pNVM1 + SIZEOF(sPersistent_1);
IF pNVM2^.NVM2_NEEDS_INIT <> DEFAULTS2.NVM2_NEEDS_INIT THEN
	SysMemCpy(pNVM2, ADR(DEFAULTS2), SIZEOF(sPersistent_2));
	RESET_NVM2 := TRUE;
END_IF

(* Managing the persistent storage area by hand here. *)
pNVM3 := pNVM2 + SIZEOF(sPersistent_2);
IF pNVM3^.NVM3_NEEDS_INIT <> DEFAULTS3.NVM3_NEEDS_INIT THEN
	SysMemCpy(pNVM3, ADR(DEFAULTS3), SIZEOF(sPersistent_3));
	RESET_NVM3 := TRUE;
END_IF

(* Managing the persistent storage area by hand here. *)
pNVM4 := pNVM3 + SIZEOF(sPersistent_3);
IF pNVM4^.NVM4_NEEDS_INIT <> DEFAULTS4.NVM4_NEEDS_INIT THEN
	SysMemCpy(pNVM4, ADR(DEFAULTS4), SIZEOF(sPersistent_4));
	RESET_NVM4 := TRUE;
END_IF

REMAINING_BYTES_OF_NVM := 
	// block 2 of nvm memory = 2303 kB:
	2358 - 
    (
	TO_UDINT(SIZEOF(sPersistent_1)) +
    TO_UDINT(SIZEOF(sPersistent_2)) +
    TO_UDINT(SIZEOF(sPersistent_3)) +
    TO_UDINT(SIZEOF(sPersistent_4))
	);

(*  force all nvm to update
SysMemCpy(pNVM1, ADR(DEFAULTS1), SIZEOF(sPersistent_1));
RESET_NVM1 := TRUE;

pNVM2 := pNVM1 + SIZEOF(sPersistent_1);
SysMemCpy(pNVM2, ADR(DEFAULTS2), SIZEOF(sPersistent_2));
RESET_NVM2 := TRUE;

pNVM3 := pNVM2 + SIZEOF(sPersistent_2);
IF pNVM3^.NVM3_NEEDS_INIT <> DEFAULTS3.NVM3_NEEDS_INIT THEN
	SysMemCpy(pNVM3, ADR(DEFAULTS3), SIZEOF(sPersistent_3));
	RESET_NVM3 := TRUE;
END_IF

pNVM4 := pNVM3 + SIZEOF(sPersistent_3);

SysMemCpy(pNVM4, ADR(DEFAULTS4), SIZEOF(sPersistent_4));
RESET_NVM4 := TRUE;
//*)

PreserveSettingsForDeprecatedVars();

(* Allow the PLC to keep running if the voltage drops below 8 but not to 0.  This happens when the system
	is started from the Accessory switch position when the machine is cool or cold. *)
ifmDevice.Reset(eResetTypes:= ifmDevice.RESET_TYPE.POWER_RECOVER);
