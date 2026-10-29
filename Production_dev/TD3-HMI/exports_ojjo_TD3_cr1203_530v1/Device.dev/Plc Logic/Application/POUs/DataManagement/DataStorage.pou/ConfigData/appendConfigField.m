
(********************** Declaration ****************************)
METHOD appendConfigField  : BOOL
VAR_INPUT
	sKey : STRING(255);
	sValue : STRING(255);
END_VAR

(********************** Implementation ****************************)
APPEND := '  "';
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := sKey;
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := '": ';
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := sValue;
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := ',$R$N';
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

appendConfigField := TRUE;