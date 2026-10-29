
(********************** Declaration ****************************)
METHOD airCompressorTempColor : DWORD
VAR_INPUT
	TEMP: REAL;
END_VAR

(********************** Implementation ****************************)
IF TEMP > 118 OR TEMP < -40 THEN
	airCompressorTempColor := colorRed(16#FF);
ELSIF TEMP > 110 OR TEMP < 38 THEN
	airCompressorTempColor := colorYellow(16#FF);
ELSE
	airCompressorTempColor := colorGreen(16#FF);
END_IF

