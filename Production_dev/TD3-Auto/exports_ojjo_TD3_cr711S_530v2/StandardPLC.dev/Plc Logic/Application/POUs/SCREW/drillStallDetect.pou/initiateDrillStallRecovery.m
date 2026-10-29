
(********************** Declaration ****************************)
METHOD initiateDrillStallRecovery
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// Upper rotary stall detected, change state to screw drive assist to save hammering.
UR_STALL_DETECTED := 1;
// The stall detect can come and go, but this recovery flag is latched for the rest of screw drive.
UR_STALL_RECOVERY := TRUE;
