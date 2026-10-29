
(********************** Declaration ****************************)
METHOD airCompressorPressureColor : DWORD
VAR_INPUT
	PRESSURE: REAL;
END_VAR

(********************** Implementation ****************************)
IF PRESSURE > 160 OR PRESSURE < 110 THEN
	airCompressorPressureColor := colorRed(16#FF);
ELSIF PRESSURE > 150 OR PRESSURE < 130 THEN
	airCompressorPressureColor := colorYellow(16#FF);
ELSE 
	airCompressorPressureColor := colorGreen(16#FF);
END_IF

