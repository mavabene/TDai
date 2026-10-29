
(********************** Declaration ****************************)
METHOD changeState
VAR_INPUT
	newState: eXyzTrueMotionStates;
END_VAR

(********************** Implementation ****************************)
STATE := newState;

(* Latch starting positions of all axes.  Also, anything that is accummulcated as we move along in
	true motion state must be reset here! *)
X_SLIDE_START := AXES[AXiS_X_SLIDE].FEEDBACK.POSITION_ENGR;
X_SLIDE_POS_SETPOINT := X_SLIDE_START;
X_SLIDE_VEL_SETPOINT := 0;
X_SLIDE_POS_DELTA := 0;

BOOM_SWING_START := AXES[AXiS_BOOM_SWING].FEEDBACK.POSITION_ENGR;
BOOM_SWING_POS_SETPOINT := BOOM_SWING_START;
BOOM_SWING_VEL_SETPOINT := 0;
BOOM_SWING_POS_DELTA := 0;
S_DELTA := 0;

Z_SLIDE_START := AXES[AXiS_Z_SLIDE].FEEDBACK.POSITION_ENGR;
Z_SLIDE_POS_SETPOINT := Z_SLIDE_START;
Z_SLIDE_VEL_SETPOINT := 0;
Z_SLIDE_POS_DELTA := 0;

(* Start master position running. *)
US_START := US;
POSITION_MASTER := 0;