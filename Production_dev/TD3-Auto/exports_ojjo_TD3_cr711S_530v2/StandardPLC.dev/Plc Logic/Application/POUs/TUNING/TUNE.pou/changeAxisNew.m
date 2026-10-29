
(********************** Declaration ****************************)
METHOD changeAxisNew : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
(* Change the selected axis.  We do NOT tune axes that only operate under manual control:
	- Left track
	- Right track
	- Mast slide
	- Upper rotary
	- Pendulum
*)
VIS_NEXT_AXIS := FALSE;

CASE VIS_AXIS OF
	0:
		// Powerup case.
		VIS_AXIS := AXIS_BOOM_SWING;
	AXIS_BOOM_SWING:
		VIS_AXIS := AXIS_PITCH;
	AXIS_PITCH:
		VIS_AXIS := AXIS_X_SLIDE;
	AXIS_X_SLIDE:
		VIS_AXIS := AXIS_YAW;
	AXIS_YAW:
		VIS_AXIS := AXIS_Z_SLIDE;
	AXIS_Z_SLIDE:
		VIS_AXIS := AXIS_ROTATOR;
	AXIS_ROTATOR:
		VIS_AXIS := AXIS_MAST_SLIDE;
	AXIS_MAST_SLIDE:
		VIS_AXIS := AXIS_LOWER_CROWD;
	AXIS_LOWER_CROWD:
		VIS_AXIS := AXIS_LOWER_ROTARY;
	AXIS_LOWER_ROTARY:
		VIS_AXIS := AXIS_UPPER_CROWD;
	AXIS_UPPER_CROWD:
		VIS_AXIS := AXIS_BOOM_LIFT;
	AXIS_BOOM_LIFT:
		VIS_AXIS := AXIS_JOINT_LIFT;
	AXIS_JOINT_LIFT:
		VIS_AXIS := AXIS_BOOM_SWING;
	ELSE
		(* Should never get here!  Just generate an error below. *)
		VIS_AXIS := 0;
END_CASE

(* Update the axis pointer, and then setup the display. *)
pAxis := ADR(AXES[VIS_AXIS]);
VIS_SELECTED_AXIS := AXIS_NAMES[VIS_AXIS];
VIS_POS_UNITS := CONCAT('P units: ', pAxis^.CONFIG.P_UNIT_NAME);
VIS_VEL_UNITS := CONCAT('V units: ', pAxis^.CONFIG.V_UNIT_NAME);

pLOCAL_AXIS := pAxis;
VIS_VFF_PLUS := pAxis^.CONFIG.SPEED_PLUS_MAX;
VIS_VFF_PLUS_LAST := VIS_VFF_PLUS;
VIS_VFF_MINUS := pAxis^.CONFIG.SPEED_MINUS_MAX;
VIS_VFF_MINUS_LAST := VIS_VFF_MINUS;
VIS_ISUM_MAX := pAxis^.LOOP_PID.INTEGRATOR_MAX;
CYCLE_PLUS := pAxis^.CONFIG.CYCLE_PLUS;
CYCLE_MINUS := pAxis^.CONFIG.CYCLE_MINUS;
VELOCITY := pAxis^.CONFIG.CYCLE_VEL;
ACCELERATION := pAxis^.CONFIG.CYCLE_ACCEL;
