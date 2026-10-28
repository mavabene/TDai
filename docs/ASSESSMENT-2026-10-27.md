# Initial assessment — October 27, 2026

Status: documentation and targeted static review. This is a dated snapshot of
the [identified inputs](SOURCE_BASELINE.md), not a complete code audit, release
approval, or machine validation. No PLC/HMI implementation was changed.

## Guidance adaptation

The user asked to adapt coworker examples to this TD3 project. Their embedded
instructions were assessed as reference material rather than executed as user
requests. The [agent guidance](../AGENTS.md), proposed during this assessment and
subsequently reviewed with the owner, makes these choices:

| Reference idea | Disposition for TD3 |
| --- | --- |
| One maintained home per fact; read current position first | Retain through README and the document ownership map |
| Separate requirements, implementation, evidence, and proposals | Retain explicitly |
| Readable ST review and copy/paste handoff | Retain; owner explicitly selected reviewable code and exact paste locations in this chat |
| Read-only exports in the initial phase | Apply to this documentation/assessment scope; future handoff also follows the owner's copy/paste preference |
| Clear POU paths and separate declarations/implementation | Retain |
| Controls-oriented explanations, fault/recovery reasoning | Retain without assuming the coworker's personal learning needs |
| PLC owns machine control; HMI handles interaction/data | Use as a proposed design rule informed by the actual source; HMI-loss independence still needs evidence |
| AD/Bravo targets, task rates, library versions, “SafetyPLC unused” | Replace with TD3 observations; do not import those assumptions |
| Polaris Kotlin/Linux/tablet work, chat helper, RT lab contract | Exclude; not this project or authorized work |
| Polaris production v5.0.4 compatibility baseline | Exclude; this assessment uses the supplied 530v1 development archives |
| Treat exports as the running machine | Reject as an inference; deployed version needs configuration evidence |
| Private Git roots, PR/merge rules, hosting and CI policy | Leave as a TD3 workflow decision; this workspace currently has no Git root |
| Copy every historical path, checker, brand guide, tutorial | Exclude unavailable and unrelated tooling/documentation |

The original machine note is useful but is not a complete kinematic specification.
Its physical conventions are preserved in [GEOMETRY](GEOMETRY.md) with their
provenance and limits.

## Findings to address before dependent targeting changes

Priority here means review order for relevant development, not a certified safety
classification. Findings remain open until their owning change/result record
resolves them.

### F-01 — Pitch coupling uses a value not assigned in the function body

Evidence: P-TARGETS, local declaration line 21 and active pitch block lines
101–108. `Z_ADJUST_FINAL` is initialized to zero, and the implementation never
assigns it. The active calculation includes:

```text
Z_OFFSET_BEGIN := Z_OFFSET_BEGIN / COS_DEG(MIN(89, pNVM1^.TORQUE_TUBE_PITCH))
                  - X_OFFSETS[6] * SIN_DEG(pNVM1^.TORQUE_TUBE_PITCH);
X_ADJUST_FINAL := X_OFFSETS[6]
                  - SIN_DEG(pNVM1^.TORQUE_TUBE_PITCH) * Z_ADJUST_FINAL;
```

The same block says `TODO: confirm signs on this`. Source therefore does not
implement an updated Z-dependent term in the X calculation as its expression
suggests. This is more specific than a generic “uninitialized variable” report:
the declaration supplies zero, but no calculated value is assigned here.

Disposition: derive the intended coupled X/Z correction using the confirmed GPS
frame and mechanism, then compare level and pitched cases. Do not guess that
replacing the variable with another Z value is correct. The `MIN(89, pitch)` term
also needs review against the permitted negative and positive pitch range; the
comment alone does not establish a complete singularity policy.

### F-02 — ASIN bounds handling loses the negative sign outside its domain

Evidence: P-ASIN, lines 12–16:

```text
IF ABS(VALUE) > 1 THEN
    VALUE := MAX(MIN(VALUE, -1),1);
END_IF
```

For `VALUE = -1.01`, the inner `MIN` returns -1.01 and the outer `MAX` returns
+1. For `VALUE = +1.01`, the result is also +1. Thus every finite out-of-domain
input is replaced by +1. P-TARGETS calls this helper for the boom-swing inverse
calculation. An unreachable negative lateral request can therefore receive the
same limiting angle as a positive request at this helper boundary.

This establishes an arithmetic defect in the stated bounds handling; it does
not establish an actual unintended motion, because downstream limits/permissives
were not fully traced. Decide explicitly whether invalid reach should saturate
with the correct sign, invalidate the target, or use another specified response.
Verify both signs and the downstream invalid-target behavior before a repair.

### F-03 — ET2 test value 86 cannot reach its stated reset branch

Evidence: P-ADJUST, lines 67–90. `IF ET2_TEST > 70 THEN` executes a block that
returns before `ELSIF ET2_TEST = 86`. Since 86 is greater than 70, that `ELSIF`
cannot run. The later reset condition also includes value 86, but the earlier
return prevents reaching it on that call.

The leading block clears the sum and writes outgoing adjustments, but its
value-86 path does not perform the component-vector reset expressed below it.
This matters when interpreting tests or cleanup between test states. The
subsequent runtime effect of retained components was not established.

Disposition: inventory test modes and their expected reset/exit behavior before
using this hook as validation evidence or changing it. This assessment did not
activate any test mode.

### F-04 — Coordinate comments conflict with the supplied physical convention

Evidence: P-BS line 8 says positive X is toward the rear operator. GEO-06 says
positive X is forward; P-TARGETS input comments also describe forward-positive X.
P-BS line 32 initializes the endpoint to `[-L,0,0]`, while its surrounding
geometry comments give inconsistent endpoint/axis descriptions.

Disposition: preserve the supplied physical convention and derive each helper's
actual input/output frame, origin, handedness, and angle conversion. Correct
comments with the eventual reviewed implementation; do not reverse an axis just
to reconcile a label. This is not yet proof the helper's executable transform is
wrong.

## Baseline and verification gaps

| ID | Observation | Required follow-up |
| --- | --- | --- |
| G-01 | PLC active version is `5.3.0v1`; HMI active version is `dev` | Use archive hashes for review identity and establish a release/version policy before rollout |
| G-02 | PLC/HMI refer to different TD3 framework versions | Inspect exact resolved types, dependencies, and compatibility; difference alone is not a defect |
| G-03 | SafetyPLC entry is empty; StandardPLC task watchdog is disabled | Establish actual controller/safety/stop architecture and intended task monitoring; do not inherit “unused” from AD |
| G-04 | HMI archive lacks `.visu` screen-definition files | Inspect project/visualization artifacts when a milestone affects UI or operator workflow |
| G-05 | Library sources, build environment, calibration snapshot, and rig identity are not established | Collect the minimum evidence for the selected milestone; see the question register |

G-03 records source configuration, not a recommendation to enable a watchdog or
move control into SafetyPLC without a system-level design and timing review.

## Interface check

The seven PLC-to-HMI and two HMI-to-PLC network-variable pairs were compared
statically. The comparison removed comments and ignored initial values, then
compared top-level declaration names, order, and whitespace-normalized type text.

| Sender -> receiver | Fields on each side | Result |
| --- | ---: | --- |
| `PLC_TRANSMIT_1.gvl` -> `RECEIVE_1` | 242 | Match |
| `PLC_TRANSMIT_2.gvl` -> `RECEIVE_2` | 126 | Match |
| `PLC_TRANSMIT_3.gvl` -> `RECEIVE_3` | 62 | Match |
| `PLC_TRANSMIT_4_ONCE.gvl` -> `RECEIVE_4_ONCE` | 2 | Match |
| `PLC_TRANSMIT_5.gvl` -> `RECEIVE_5` | 97 | Match |
| `PLC_TRANSMIT_6.gvl` -> `RECEIVE_6` | 36 | Match |
| `PLC_TRANSMIT_7_GPS.gvl` -> `RECEIVE_7_GPS` | 48 | Match |
| HMI `TRANSMIT_1.gvl` -> PLC `PLC_RECEIVE_1` | 116 | Match |
| HMI `TRANSMIT_2.gvl` -> PLC `PLC_RECEIVE_2` | 127 | Match |

Evidence: P-NV and H-NV; 856 paired top-level declarations in total. This check
does not resolve named types from the differing framework libraries, structure
packing, list IDs, transport configuration, validation of received settings,
startup synchronization, stale-data handling, or communications failure behavior.
It is not proof of binary or runtime compatibility.

## Coverage and limits

Completed: source/document provenance and hashes; archive inventory; active
version/framework declarations; task configurations; PLC/HMI scan entry points;
GPS target/adjustment entry points; selected CAN decode/transmit statements;
geometry/comment comparison; top-level network declarations; initial stop-control
navigation; guidance adaptation and documentation structure.

Not completed: a full actuator/output audit; all CAN bytes/vendor variants;
decoded framework/motor implementations; full stop/hydraulic circuit validation;
screen bindings; full NVM/configuration migration analysis; storage/uplink
integrity under concurrency; complete kinematic derivation; CODESYS compile;
simulation; controller or machine testing; deployed-version confirmation.

Only temporary export copies and project documentation were written. Original
archives, geometry note, and the two adjacent development project binaries were
rehashed at handoff to check preservation. The original coworker examples were
copied unchanged under `AI info/reference-guidelines/` for provenance.

## Recommended follow-up

Use a separate milestone chat for the likely new locating process, as the owner
intends. Start with its current/desired operator sequence, active reference
point, acceptable position/orientation, error/failure handling, and validation
configuration. Resolve F-01/F-02 and relevant frame definitions before relying on
the current targeting calculation as its reference model. Broad modernization,
library refactoring, and release automation are separate scope decisions.
