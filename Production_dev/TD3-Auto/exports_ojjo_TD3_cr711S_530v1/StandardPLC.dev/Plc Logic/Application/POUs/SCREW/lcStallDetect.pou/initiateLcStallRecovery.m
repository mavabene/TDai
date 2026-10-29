
(********************** Declaration ****************************)
METHOD initiateLcStallRecovery
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
//HARD_SOIL_DETECTED := TRUE;
// LC_STALL_DETECTED := 1;

(*
LC_STALL_DETECT_MODE 0 = none
LC_STALL_DETECT_MODE 1 = Lower Rotary Advance
LC_STALL_DETECT_MODE 2 = brief hammer

LC_STALL_DETECTED 0 = none
LC_STALL_DETECTED 1 = detected and LC_STALL_DETECT_MODE is 0
LC_STALL_DETECTED 2 = detected and Lower Rotary Advance mode
LC_STALL_DETECTED 3 = detected and brief hammer mode

*)
LC_STALL_DETECTED := pNVM4^.HMI_SINTS[LC_STALL_DETECT_MODE] + 1;
// debug[446] := LC_STALL_DETECTED; 