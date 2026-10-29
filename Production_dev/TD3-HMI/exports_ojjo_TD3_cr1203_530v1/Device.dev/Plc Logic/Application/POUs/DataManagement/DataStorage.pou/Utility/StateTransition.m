
(********************** Declaration ****************************)
METHOD StateTransition : BOOL
VAR_INPUT
	NEW_STATE: eDataAcqState;
	NEW_RESULT: eDataAcqErr;
	NEW_LOG_RESULT: STRING;
	NEW_LOG_STATE: STRING;
END_VAR

(********************** Implementation ****************************)
STATE := NEW_STATE;
RESULT := NEW_RESULT;
LOG_RESULT := NEW_LOG_RESULT;
LOG_STATE := NEW_LOG_STATE;
