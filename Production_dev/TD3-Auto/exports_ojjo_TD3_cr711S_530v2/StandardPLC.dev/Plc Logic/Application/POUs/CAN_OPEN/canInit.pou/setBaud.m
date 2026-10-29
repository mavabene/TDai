
(********************** Declaration ****************************)
METHOD setBaud : ifmDevice.CAN_BAUDRATE
VAR_INPUT
	B: UINT;
END_VAR

VAR
	RVAL: ifmDevice.CAN_BAUDRATE;
END_VAR

(********************** Implementation ****************************)
CASE B OF
	1000:
		RVAL := ifmDevice.CAN_BAUDRATE.KBAUD_1000;
	800:
		RVAL := ifmDevice.CAN_BAUDRATE.KBAUD_800;
	500:
		RVAL := ifmDevice.CAN_BAUDRATE.KBAUD_500;
	250:
		RVAL := ifmDevice.CAN_BAUDRATE.KBAUD_250;
	125:
		RVAL := ifmDevice.CAN_BAUDRATE.KBAUD_125;
	ELSE
		RVAL := ifmDevice.CAN_BAUDRATE.KBAUD_125;
END_CASE
setBaud := RVAL;