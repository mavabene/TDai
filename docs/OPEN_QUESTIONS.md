# Open information and decisions

Status: October 27, 2026. This is the maintained question register. Resolve each
item in the relevant requirement, geometry, hardware, interface, or workflow
record, then add a link here. Do not turn unknowns into numerical defaults.

The owner has already selected reviewable copy/paste code with exact paste
locations; [DEVELOPMENT](DEVELOPMENT.md) owns that handoff. Separate chats will
address milestones, with a new locating process likely first. Its scope and rig
configuration remain unspecified.

## Needed to scope the locating milestone

| ID | Missing information | Why / next evidence |
| --- | --- | --- |
| Q-01 | Current locating sequence and desired replacement: operator actions, automatic motions, entry/exit, completion, interruption, retry, and manual recovery | Establish behavior before designing states; obtain an example normal cycle and a failed/interrupted cycle |
| Q-02 | Validation rig identity and configuration: serial/model, installed options, PLC/HMI versions, GPS vendor/firmware, remote, controller firmware, and relevant library set | Tie results to the actual machine; exports are the review baseline but not deployment evidence |
| Q-03 | Products and operations included in the first milestone: SI/Earth Truss variants, array/motor/third leg, locating before screw drive or assembly/crimping | Select the active reference and adjustment branches; do not broaden to every product automatically |
| Q-04 | Acceptance criteria: position/orientation limits, repeatability, settle/dwell behavior, cycle-time goals, terrain/attitude envelope, and operator indication of success | Define measurable completion and failure; no new tolerance numbers have been chosen |
| Q-05 | Locating permissives and recovery: GPS loss/stale data, point change, HMI/remote loss, sensor fault, unreachable target, mode change, stop/reset, power interruption | Define which data and states remain valid, what stops, and what can resume |

## Geometry and interface definitions needed by dependent calculations

These are the remaining gaps from GEO-06. The direction/mounting facts listed
later are already recorded and should not be asked again as unknowns.

| ID | Missing information | First place to retrieve or confirm |
| --- | --- | --- |
| Q-06 | Numerical WP/pin/COR relationships by product and operation, including nominal mast-slide/lower-crowd reference positions and exceptions | Product drawings, existing geometry constants, calibration records, actual rig settings; distinguish code default from measured value |
| Q-07 | Pitch/roll zero poses, positive directions, pivot coordinates, sensor mounting, all relevant mechanical offsets and joint limits | Mechanical drawings, actuator setup and calibration; then trace each conversion helper |
| Q-08 | GPS X/Y definition with tilted plate: horizontal projection or other attitude convention; positive heading-error physical sense | Applicable vendor protocol/configuration plus a documented reference observation |
| Q-09 | GPS configured antenna/reference geometry and active PLC target-adjustment contract by vendor, product, and stage | GPS configuration export, CAN specification/DBC and representative capture; include units, signs, signed width, range, invalid codes, timing, and acknowledgment if applicable |
| Q-10 | PNEZD coordinate system, units, datum, vertical reference/geoid, precision, point identity and complete description encoding | Real design-file examples and vendor/project specification; align parsing and stored as-built meaning |
| Q-11 | Calibration ownership and persistence: which settings are in PLC NVM, HMI, or GPS, how saved/restored, and what makes calibration valid | Per-rig configuration snapshots and existing load/save code; identify which changes invalidate prior calibration |

## Foundation for sustained development

| ID | Missing information | Needed before |
| --- | --- | --- |
| Q-12 | Exact CODESYS IDE/compiler/patch, target/device packages, firmware, installed libraries and resolved versions, licenses, reproducible project archive | Claiming a reproducible build or applying a proposed patch in the IDE |
| Q-13 | Readable sources and version history for the referenced TD3 framework and motor/control libraries | Reviewing shared type layout, motion-control internals, dependencies, or library changes; framework references differ in this pair |
| Q-14 | Electrical/CAN/I/O drawings and hydraulic schematics: sensor scales, valve commands/neutral behavior, engine interface, pressure limits and load-holding behavior | Evaluating physical consequences of control/output changes; create a configuration-specific record rather than assuming a fleet default |
| Q-15 | Actual stop/safety architecture, controller roles, fault matrix, reset/restart behavior, and available machine test procedures | Endorsing stop/permissive changes or machine operation; empty SafetyPLC code is not a substitute for this information |
| Q-16 | HMI screen definitions and affected bindings, navigation, access levels, alarms, and operator instructions | A locating workflow or display change; current text exports do not include screen definitions |
| Q-17 | Available verification environment: offline simulation, bench harness, logging/captures, reference measurements, responsible operator, and release/rollback procedure | Planning tests that can actually be run and defining their practical limits |
| Q-18 | Remaining release naming/approval rules and resolution of the protected Box PLC difference | Git root, remote, initial tracking scope, and latest-only Box-copy policy are recorded in [DEVELOPMENT](DEVELOPMENT.md); Box updates are on hold |
| Q-19 | As-built event meaning and data retention: reference point at capture, source freshness, configuration identity, queue/storage/uplink behavior on failure | Changing completion, locating records, data format, or storage/uplink; avoid equating a GPS flag with a verified finished position |

## Already recorded physical context

GEO-06 establishes forward/right/up left-handed machine axes; plate-aligned GPS
X/Y and plumb Z; positive movement-to-target offsets; opposite boom-swing/yaw
feedback signs; X-slide travel opposite GPS X in the aligned geometry; pitch of
the whole assembly; roll of the mast rather than the Z-slide backbone; and SI
WP-based versus Earth Truss pin-based referencing. See [GEOMETRY](GEOMETRY.md).
These are supplied physical context, not newly measured facts. Ask for new
evidence only if a task reveals a conflict or depends on a documented exception.

The [assessment findings](ASSESSMENT-2026-10-27.md) are tracked separately from
missing information. Collect only the information needed for the selected
milestone; the complete register is not a prerequisite for more documentation.
