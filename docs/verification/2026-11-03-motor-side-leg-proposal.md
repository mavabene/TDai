# Track-entry GPS adjustment reset proposal

Status: revised, unapplied copy/paste proposal, November 3, 2026.
The owner proposed using isNewModeEnabled() in the existing reset block; this
supersedes the earlier GpsUpdate edge-variable proposal. No source/project edits
or application of either proposal have been reported.

## Baseline, timing and effect

PLC-530: `Production_dev/TD3-Auto/exports_ojjo_TD3_cr711S_530v1.zip`, SHA-256
`a6a5631cf65a7353bffe910c6bf18b8044e5a59df4071fb1e249fc62888f8ea5`.
Member: `exports_ojjo_TD3_cr711S_530v1/StandardPLC.dev/Plc Logic/Application/POUs/GPS/modifyTarget/setGPSpNEZdTargetAdjust.pou`.
The local 530v2 adjustment POU is byte-identical. Deployed source remains unverified.

Finding MLT-05: the existing reset waits for a new point or CROWDS_DOWN;
manual Track skips CROWDS_DOWN. Its reset also omits the high-WP latch/reduction.
Root cause of the intermittent field failure remains unconfirmed.

Use the existing new-mode pulse together with MACHINE_MODE = TRACK_MODE.
In PLC_PRG, GPS_01/GpsUpdate runs before machineState/OperatorState. The inspected
framework candidate td3_31012 isNewModeEnabled returns NEW_MODE_ENABLED, which
OperatorState clears at entry and sets when the 500 ms mode-selection delay
finishes. GPS therefore sees the pulse on the following scan, before
OperatorState clears it. This is suitable for resetting after Track is enabled;
it is not an immediate reset at the initial mode-switch request. This timing
claim assumes the inspected cyclic order and library behavior. Load/unload-only
mode takes a separate framework path and is not covered as normal installation.

## Paste location

CODESYS: StandardPLC > Application > POUs > GPS > modifyTarget >
setGPSpNEZdTargetAdjust. No declaration changes.
Replace the complete existing implementation block beginning
`(* ** RESET VALUES WHEN NEW POINT SIGHTED OR RESTARTING POSITIONING ** *)`
and ending at its matching END_IF immediately before `(* ----- TRUSS FRAME ----- *)`
with:

```iecst
(* ** RESET VALUES WHEN NEW POINT SIGHTED OR RESTARTING POSITIONING ** *)
IF IS_NEW_PILE_LOCATION
    OR ((MACHINE_MODE = TRACK_MODE) AND isNewModeEnabled())
    OR ((MACHINE_MODE = TRACK_MODE)
        AND (TRACK_STATE = TRACK_STATE_CROWDS_DOWN))
    OR (ET2_TEST = 86) THEN

    PNEZD_ADJUST_NORTHING := 0;
    PNEZD_ADJUST_EASTING := 0;
    PNEZD_ADJUST_Z := 0;

    GPS_THIRD_LEG_ADJUST_ON := FALSE;
    NXT_MOTOR_THIRD_LEG_ADJUST := ZERO_VECTOR;
    VERT_TO_PITCHED_MAST_ADJ := ZERO_VECTOR;
    RAW_PITCHING_MAST_WP_OFFSETS := ZERO_VECTOR;

    WP_HEIGHT_LATCH := WP_NONE;
    HIGH_WP_SIDE_LEG_AXIS_REDUCTION := 0;
    HIGH_WP_SIDE_LEG_Y_OFFSET := 0;
    HIGH_WP_SIDE_LEG_ADJUST := ZERO_VECTOR;

    NXT_LOCATION_ADJUST := ZERO_VECTOR;
    NXT_MOTOR_SIDE_LEG_ADJUST := ZERO_VECTOR;
    PEDESTAL_ADJ_PREDICT := ZERO_VECTOR;
    TRUSS_FRAME_VECTOR_SUM := ZERO_VECTOR;
    MAST_AND_LOWERCROWD_TO_COR_ADJUST_WORLD_FRAME := ZERO_VECTOR;
    MAST_AND_LOWERCROWD_TO_COR_ADJUST_MAST_FRAME := ZERO_VECTOR;
END_IF
```

Keep the existing downstream calculation and original GpsUpdate call unchanged.
If the earlier proposal was pasted, remove TRACK_MODE_WAS_ACTIVE and its added
reset section in GpsUpdate, restoring its original single adjustment call.
No new variable, caller, type, library, persistent layout, HMI field, network
field or calibration change is required for this revision.

## Behavior and limits

The original reset triggers remain. The added latch/reduction/raw-prediction
resets apply to every trigger in this block, including new points and CROWDS_DOWN.
Normal recalculation follows in the same call: outputs need not all be zero.
A recognized right/left switch with ET2_TEST=0 selects side-leg corrections and
clears third-leg/pitch-prediction vectors. Center selection can legitimately
reapply third-leg corrections under the existing eligibility conditions; this
is not a lockout or rearm rule. Do not add RETURN after the reset.

Existing early ET2_TEST > 70 return remains ahead of this block. In particular,
the existing ET2_TEST=86 reset clause remains unreachable through that early
return; correcting debug mode is outside this patch. Normal validation uses 0.

No geometry transform or unit convention changes. Reset vectors retain their
existing truss/mast/world meaning and millimeter units. No state transition or
motion request is added; recalculated targets can affect current automatic
tracking under existing state/axis-selection/permissive/output-limit gates.
Screw positioning, track-back and stop/fault logic remain in their existing paths.

## Validation and next action

Performed: static caller/flag-lifetime review and source comparison. A Boolean
mode-entry truth table checked pulse with Track, no pulse with Track, and pulse
outside Track. These are not ST execution or a compile. No controller connection,
download, online change or machine operation occurred.

Before acceptance: compile in the owner's configuration and observe normal
Screw-to-Track return on the same point in automatic and manual. Confirm the
pulse is visible here once per enabled-mode transition; check right/left/center,
new point, normal array/motor products, WP_HIGH/WP_NONE, GPS loss/recovery,
rapid mode cycling and fault recovery. Verify outgoing adjustments and returned
GPS feedback, and retain clearance/track-back behavior. Field cause is not yet
verified. Rollback restores the original reset block as a whole.

Related [investigation](2026-11-03-motor-leg-transition.md).
