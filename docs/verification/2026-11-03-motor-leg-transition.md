# Motor third-leg to side-leg transition: static investigation

Owner report, November 3, 2026: after completing a motor third leg and selecting
right leg, adjustment sometimes appears unchanged; tracking away and returning
recovers it. Runtime cause remains unconfirmed.

## Source and limits

PLC-530 archive and SHA-256 are identified in SOURCE_BASELINE.md. Archive hash
was rechecked; extracted setGPSpNEZdTargetAdjust.pou and GpsUpdate.pou match
their archive members exactly. The local 530v2 adjustment POU is byte-identical
to 530v1. This does not establish deployed source. Application paths below are
relative to `exports_ojjo_TD3_cr711S_530v1/StandardPLC.dev/Plc Logic/Application/`.
The matching-version candidate framework getter was also read from
`.export-work/libraries-2lswj7/10/exports_td3_31012/POUs/Remote/getScrewSide.pou`:
it reads T3P3_DN/UP directly; neither active means center. Resolved controller
library identity has not been verified.

## Findings

- **MLT-01 (observed):** `POUs/GPS/modifyTarget/setGPSpNEZdTargetAdjust.pou`
  lines 128-196 clears the third-leg flag/vector and selects the side vector
  on a recognized side selection in normal operation (`ET2_TEST=0`). It is
  called at GpsUpdate line 371. There is no normal-path missing ELSE reset
  in this motor-vector branch. Test overrides are an exception.
- **MLT-02 (candidate cause):** the same POU lines 273-288 assesses high WP
  only during qualifying tracking or entry to RWP GPS_FAST_TARGET. A center
  to right transition in screw mode does not reassess it. Lines 291-335 use
  that latch to retain/apply high-WP reduction. The new-point reset in
  `POUs/GPS/GpsUpdate.pou` lines 252-280 resets latch and reduction only for
  a stable changed point ID in track mode. Returning to the same point does
  not necessarily execute this new-point reset, although other tracking/RWP
  paths can refresh positioning.
- **MLT-03 (candidate consequence):**
  `POUs/Utility/checkConditions/isScrewModeGpsAdjustNeeded.pou` requires
  GPS_USED_THIS_TRUSS and (third-leg latch OR WP_HIGH). The initial-rotate
  method requests GPS movement only on FIRST_IN_LEVEL. In
  `POUs/SCREW/screwStateMachine.pou/ScrewStateMastToTarget.m`, the subsequent
  GPS adjustment state likewise depends on third-leg/high-WP conditions.
  A side selection with WP_NONE can therefore have changed target offsets
  without triggering the required side-leg repositioning sequence.
- **MLT-04 (observed limit):** live remote selection controls target vectors,
  while SCREW_SIDE_LATCH updates on confirm in ScrewStateLoadScrew.m, line 24.
  These can temporarily disagree. X_SLIDE.pou gates GPS use by state,
  automatic/permissive and cycle; its target ultimately passes through
  TrapezoidRun/LoopPID/HaweOutput. A changed target is not proof of motion.
  GPSdata.m packs revised N/E adjustments periodically for vendors 1 and 3,
  including zero values. Receipt/application by the GPS was not observed.

## Next evidence and proposed correction direction

Capture a failing transition: product, D string, decoded/current truss type,
T3P3_UP/DN, screw-side latch, mode/state, ET2_TEST, third-leg flag/vector,
side-leg vector, high-WP latch/vector/reduction, final PNEZD adjustments,
GPS offsets, GPS_TRUSS_CYCLE and GPS_AUTOTARGET_ACTUATE. This distinguishes
selection failure, stale auxiliary adjustment, GPS transport and missing motion.

Proposal only: treat third-to-side transition as an explicit positioning
transition, refresh applicable height assessment using the new reference after
GPS feedback settles, and request movement only in an appropriate positioning
state. Do not globally clear all offsets or reinitialize an active drive.
Check center/right/left, high/reachable WP, switch timing around confirm,
same/new point recovery, pause/manual/fault recovery and the actual vendor path
before accepting a correction. No code edited, compile, simulation, controller
connection or machine test occurred in this investigation.

Owner clarified on November 3 that reset is required on returning to Track
after third-leg crimping. Screw-mode repositioning is not the requested change.
**MLT-05 (observed reset gap):** the existing reset waits for CROWDS_DOWN or a
new point. Automatic Track reaches that substate after clearance/track-back;
manual Track skips it. Its reset also omits the high-WP latch/reduction.
The revised [Track-entry reset proposal](2026-11-03-motor-side-leg-proposal.md)
adds the owner's suggested new-mode/Track condition to the existing adjustment
reset block, replacing the earlier GpsUpdate edge-variable proposal. Static
inspection confirms GPS sees the framework new-mode pulse on the following scan
under the inspected cyclic order. The proposal is unapplied and
does not inhibit third-leg selection if the switch remains centered. No runtime
root cause has been established; MLT-02/03 remain hypotheses, not accepted scope
for screw-mode changes.
