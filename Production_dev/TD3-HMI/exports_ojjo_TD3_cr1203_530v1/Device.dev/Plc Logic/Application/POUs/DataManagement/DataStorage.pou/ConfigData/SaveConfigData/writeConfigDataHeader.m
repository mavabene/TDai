
(********************** Declaration ****************************)
METHOD writeConfigDataHeader : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// descriptive header

DATA := 'CONFIG_SETTINGS_DATA, ';
DATA := CONCAT(DATA, '$R$N');
// write to temporary on board file
write(FH := FH_CONFIG_DATA);


DATA := 'MACHINE #:, ';
DATA := CONCAT(DATA, TO_STRING(RECEIVE_5.MACHINE_SERIAL_VALUE));
DATA := CONCAT(DATA, ', ');
// Game the TO_STRING conversion into giving us one more digit of output with some
//	accuracy, and then a whole bunch of other garbage digits.

DATA := CONCAT(DATA, '"');
DATA := CONCAT(DATA, DATETIME);
DATA := CONCAT(DATA, '"');
DATA := CONCAT(DATA, '$R$N');
// write to temporary on board file
write(FH := FH_CONFIG_DATA);