
(********************** Declaration ****************************)
METHOD _4to20mAmpColor : DWORD
VAR_INPUT
	MICROAMPS: REAL;
END_VAR

(********************** Implementation ****************************)
IF MICROAMPS > 20200 OR MICROAMPS < 3800 THEN
	_4to20mAmpColor := colorRed(16#FF);
ELSIF MICROAMPS > 20020 OR MICROAMPS < 3980 THEN
	_4to20mAmpColor := colorYellow(16#FF);
ELSE
	_4to20mAmpColor := colorGreen(16#FF);
END_IF
