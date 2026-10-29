
(********************** Declaration ****************************)
METHOD limitTurning : WORD
VAR_INPUT
	pLEFT_MAG: POINTER TO WORD;
	pRIGHT_MAG: POINTER TO WORD;
	pLEFT_POS: POINTER TO BOOL;
	pRIGHT_POS: POINTER TO BOOL;
END_VAR

VAR
	Y: REAL;
	X: REAL;
	
	NUM: REAL := 1;
	DEN: REAL := 2.4;
	OFFSET: REAL := 6;
	YITCPT: REAL := 0.38;
END_VAR
(********************** Implementation ****************************)

IF pLEFT_MAG^ > pRIGHT_MAG^ THEN
	X := TO_REAL(pLEFT_MAG^) / 1000.0;
ELSIF pRIGHT_MAG^ > pLEFT_MAG^ THEN
	X := TO_REAL(pRIGHT_MAG^) / 1000.0;
END_IF

// We want the output of the lever pushed LESS to be a ratio of the lever pushed MORE.  This ratio should be
//	higher at lower speeds, lower at higher speeds.
//
// This equation gives a ratio of about 0.4 at very low speeds (note Y intercept), and approaches 0.2 at higher speeds (note left
//	quantity goes to -0.2 as X goes to infinity.  Note the above division by 1000; we are ratioing the valve command in
//	millepercent into the 0 to 1 section of the function below.
Y := (-NUM * X / (DEN * X + OFFSET)) + YITCPT;

// IF pLEFT_MAG^ > pRIGHT_MAG^ AND Y > pRIGHT_MAG^ THEN
IF pLEFT_MAG^ > pRIGHT_MAG^
    AND (Y * TO_REAL(pLEFT_MAG^)) > TO_REAL(pRIGHT_MAG^)
	THEN
	// Left magnitude is higher, so force right to conform.
	IF pRIGHT_MAG^ < 25 THEN
		// If the operator is intentionally running both tracks in opposite directions, we will allow that.
		pRIGHT_POS^ := pLEFT_POS^;
	END_IF
	pRIGHT_MAG^ := TO_WORD(Y * pLEFT_MAG^);
ELSIF pRIGHT_MAG^ > pLEFT_MAG^
    AND (Y * TO_REAL(pRIGHT_MAG^)) > TO_REAL(pLEFT_MAG^)
	THEN
// ELSIF pRIGHT_MAG^ > pLEFT_MAG^ AND Y > pLEFT_MAG^ THEN
	IF pLEFT_MAG^ < 25 THEN
		pLEFT_POS^ := pRIGHT_POS^;
	END_IF
	pLEFT_MAG^ := TO_WORD(Y * pRIGHT_MAG^);
END_IF

