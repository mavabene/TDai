
(********************** Declaration ****************************)
METHOD writeConfigHeaderMessage : BOOL
VAR_INPUT
	sVersionKey : STRING(20);
	iFormatVersion : STRING(20);
END_VAR
(********************** Implementation ****************************)
(* ======================================================== *)
(* ------------------------ Header ------------------------ *)
(* ======================================================== *)

(* Config version *)

APPEND := '  "';
Stu.StrConcatA(
    ADR(APPEND),
    ADR(DATA),
    TO_INT(SIZEOF(DATA))
);

APPEND := sVersionKey;
Stu.StrConcatA(
    ADR(APPEND),
    ADR(DATA),
    TO_INT(SIZEOF(DATA))
);

APPEND := '": "';
Stu.StrConcatA(
    ADR(APPEND),
    ADR(DATA),
    TO_INT(SIZEOF(DATA))
);

APPEND := iFormatVersion;
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := '",$R$N';
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);


(* Machine Serial *)
APPEND := '  "Machine Serial": ';
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE);
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


(* Export Datetime *)
APPEND := '  "Export Datetime": "';
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := DATETIME;
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);

APPEND := '",$R$N';
Stu.StrConcatA(
	ADR(APPEND),
	ADR(DATA),
	TO_INT(SIZEOF(DATA))
);


writeConfigHeaderMessage := TRUE;