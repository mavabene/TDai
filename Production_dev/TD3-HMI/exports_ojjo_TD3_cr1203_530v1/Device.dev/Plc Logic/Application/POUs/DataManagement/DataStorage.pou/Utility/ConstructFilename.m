
(********************** Declaration ****************************)
METHOD ConstructFilename : BOOL
VAR_INPUT
	pFILENAME: POINTER TO STRING;
	// Signifies what screw info we are taking:
	//	- A number is simply a screw number
	//	- 'x' means this is not screw related
	//	- 'z' means this will cross multiple screws
	SCREW_ID: STRING;
	// Source is the type of data to be put in the file:
	//	- 1: classic screw drive diagnostics info
	//	- 2: cycle time monitoring
	//  - 3: GPS as built data
	//  - 4: Track Assist target accuracy data
	//  - 5: Config Data
	SOURCE_ID: STRING;
	INCLUDE_HH_MM_SS: BOOL;
END_VAR
VAR
END_VAR

(********************** Implementation ****************************)

DATETIME := ifmFileUtil.RTC_To_String(DATE_TIME);
DAY := MID(STR := DATETIME, LEN := 2, POS := 1);
MONTH := MID(STR := DATETIME, LEN := 2, POS := 4);
IF SOURCE_ID <> '5' THEN
	YEAR := MID(STR := DATETIME, LEN := 4, POS := 7);
ELSE
	YEAR := MID(STR := DATETIME, LEN := 2, POS := 9);
END_IF

HOUR := MID(STR := DATETIME, LEN := 2, POS := 12);
MINUTE := MID(STR := DATETIME, LEN := 2, POS := 15);
SECOND := MID(STR := DATETIME, LEN := 2, POS := 18);

IF SOURCE_ID = '5' THEN
	pFILENAME^ := SCREW_ID;
	pFILENAME^ := CONCAT(SCREW_ID, '_TD');
ELSE
	pFILENAME^ := 'TD';
	pFILENAME^ := CONCAT(pFILENAME^, '_D');
	pFILENAME^ := CONCAT(pFILENAME^, SOURCE_ID);
	pFILENAME^ := CONCAT(pFILENAME^, '_M');
END_IF

pFILENAME^ := CONCAT(pFILENAME^, TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE));

IF SOURCE_ID = '1' THEN
	// If we are looking at screw drive data, put a screw number into the filename.
	pFILENAME^ := CONCAT(pFILENAME^, '_S');
	pFILENAME^ := CONCAT(pFILENAME^, SCREW_ID);
ELSIF SOURCE_ID = '3' THEN
	// If we are looking at GPS As Built data, put a screw number into the filename.
	pFILENAME^ := CONCAT(pFILENAME^, '_AB');
ELSIF SOURCE_ID = '4' THEN
	// If we are looking at Track Assist Accuracy data, put a screw number into the filename.
	pFILENAME^ := CONCAT(pFILENAME^, '_TA');
END_IF

pFILENAME^ := CONCAT(pFILENAME^, '_');
pFILENAME^ := CONCAT(pFILENAME^, TO_STRING(YEAR));
IF SOURCE_ID <> '5' THEN
	pFILENAME^ := CONCAT(pFILENAME^, '-');
END_IF
pFILENAME^ := CONCAT(pFILENAME^, TO_STRING(MONTH));
IF SOURCE_ID <> '5' THEN
	pFILENAME^ := CONCAT(pFILENAME^, '-');
END_IF
pFILENAME^ := CONCAT(pFILENAME^, TO_STRING(DAY));
IF INCLUDE_HH_MM_SS THEN
	pFILENAME^ := CONCAT(pFILENAME^, '-');
	pFILENAME^ := CONCAT(pFILENAME^, TO_STRING(HOUR));
	pFILENAME^ := CONCAT(pFILENAME^, '-');
	pFILENAME^ := CONCAT(pFILENAME^, TO_STRING(MINUTE));
	pFILENAME^ := CONCAT(pFILENAME^, '-');
	pFILENAME^ := CONCAT(pFILENAME^, TO_STRING(SECOND));
END_IF
IF SOURCE_ID = '5' THEN
	pFILENAME^ := CONCAT(pFILENAME^, '.json');
ELSE
	pFILENAME^ := CONCAT(pFILENAME^, '.csv');
END_IF

