
(********************** Declaration ****************************)
METHOD manageNvmUpdates : bool
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// debugging

// IF VERSION = '4.9.4v1' THEN
// 	NVM.TECHNICIAN_PASSWORD := '4747';
// 	NVM.ENGINEER_PASSWORD := '4881';
// 	NVM.ADMIN_PASSWORD := '7887';
// 	
// 	NVM.OJJO_TECHNICIAN_PASSWORD  := '2626';
// 	NVM.OJJO_ENGINEER_PASSWORD := '1600';
// 	NVM.OJJO_ADMIN_PASSWORD := '2332';	
// 	NVM.OWNER_ENGINEER_PASSWORD := '8036';
// END_IF

IF VersionHMI.VERSION = 'dev' THEN
	OPERATOR_LEVEL := eOperatorLevel.OJJO_ADMIN;
END_IF
 

IF NVM.NVM_FORMAT_VERSION <> 2 THEN
	// initiate HMI nvm machine serial for config file comparisons
	NVM.NVM_FORMAT_VERSION := 2;
	NVM.MACHINE_SERIAL_NUMBER_FROM_PLC := RECEIVE_5.MACHINE_SERIAL_VALUE;
END_IF 