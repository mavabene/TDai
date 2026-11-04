# Standalone TD3 articulated model — build instructions

Prepared November 2, 2026. This is an implementation brief, not an implemented or
validated simulator. Build a representative laptop model of the TD3 using simple
blocks, cylinders, rails, and a simplified lattice mast. Prioritize recognizable
assemblies and correct relative movement over cosmetic detail.

## Read first and preserve

Read root AGENTS.md, README.md, [GEOMETRY](../GEOMETRY.md), and the
[image index](../../AI%20info/machine-images/2026-11-02/README.md). Open all five
images, using their descriptive filenames when discussing them. GEOMETRY owns
physical facts; this brief owns implementation scope and acceptance checks.

Keep PLC/HMI exports, projects, libraries, and unrelated owner changes intact.
No controller connection, hardware operation, PLC edits, or live I/O is included.
The 530v1 source baseline can inform naming, but do not imply this model executes
that code or represents the current deployed machine.

## First version

Provide a local interactive 3D viewer with:

- Orbit, pan, zoom, fit-to-machine, and side/end/top/isometric camera presets.
- Labeled controls for boom swing, boom lift, joint lift, yaw, X-slide, pitch,
  Z-slide, rotator/roll, mast slide, lower crowd, upper crowd relative travel,
  and upper/lower rotary rotation.
- A reference pose reset, optional pivot/axis markers, and selection highlighting
  that makes the controlled assembly easy to locate.
- Numeric joint readouts with units. Mark estimated dimensions and demonstration
  ranges clearly; do not label them as machine limits.
- Flat ground, a grid, and visible machine direction labels.
- Optional slow single-axis demonstrations with pause/stop. Direct pose controls
  are sufficient initially; demonstration speed is not hydraulic calibration.

Tracks and chassis are recognizable static geometry in this version. Driving,
terrain response, remote controls, physical inclinometer, PLC communication,
GPS emulation, pressure/load dynamics, and collision enforcement are future scope.
Show representative drill steel through a hollow ground screw; no soil mechanics
or thread contact simulation is required.

## Suggested implementation

Use a small local browser application with TypeScript and Three.js, unless an
existing suitable project structure warrants reuse. This is a proposed tool
choice, not an owner-established platform requirement. Keep dependencies small,
pin their versions, provide a lockfile, and bundle runtime assets locally so the
viewer works without internet after setup. Use the official
[Three.js documentation](https://threejs.org/docs/) for current APIs.

Place new implementation under `simulator/`. Separate geometry configuration,
joint state/kinematics, scene construction, and controls. Keep the kinematic
calculation callable without the renderer for focused verification and future
integration. Do not add networking infrastructure for hypothetical future use.

Provide Windows launch instructions with exact prerequisites and commands. If a
local server is used, bind to loopback. Include a build command and a practical
way for the owner to launch the viewer again.

## Frames and geometry configuration

Use metres internally, degrees on the controls, and radians at rotation APIs.
The machine frame is X forward, Y right, Z up and is left-handed. Define the
machine origin explicitly, preferably at the chassis boom-swing pivot. For a
right-handed rendering frame, one possible mapping is:

```text
render X = machine X
render Y = machine Z
render Z = machine Y
```

This mapping changes handedness: transform rotations consistently, not just point
coordinates. Check rotation signs with physical direction examples. Keep camera
motion separate from machine pose; do not mirror the rig to make a view look right.

Store joint origins, local axes, fixed offsets, zero poses, dimensions, display
ranges, and provenance in one configuration. Distinguish owner-confirmed facts,
source nominal dimensions, and visual estimates. The nominal 1.35 m arm lengths
and approximately 0.30 m X-slide travel in GEOMETRY are useful starting context,
not proof of measured pivot coordinates. Do not adopt screenshot distance labels
without knowing their selected endpoints and CAD frame.

## Mechanical behavior to implement

Use the confirmed facts in GEOMETRY rather than guessing from actuator names:

| Motion | Required visible behavior |
| --- | --- |
| Boom swing | Moves its arm laterally; positive recorded feedback swings it right |
| Boom lift | Extension pivots the boom lift upwards |
| Joint lift | Extension tilts the trunnion and X-slide toward the machine rear; independent of boom lift |
| Yaw | Moves the downstream assembly at the second steering pivot; positive feedback swings its arm left, opposite boom swing |
| X-slide | Moves Z-slide support and pitch-cylinder base together along the horizontal guide; increased slide position increases rearward reach in the aligned pose |
| Pitch | Tilts the Z-slide backbone and everything downstream |
| Z-slide | White member travels within red backbone and carries the rearward assemblies along its local slide axis |
| Rotator/roll | Rolls the mast/downstream assembly about COR; does not roll the Z-slide backbone |
| Mast slide | Entire red lattice mast slides through its rotator support, carrying both crowds |
| Lower crowd | Travels on mast guides, carrying lower rotary and also carrying upper crowd when upper relative travel is unchanged |
| Upper crowd | Travels relative to lower crowd, carrying upper rotary |
| Lower rotary | Rotates the ground screw about its axis |
| Upper rotary | Rotates drill steel passing through the hollow ground screw |

Model upper-crowd absolute mast position as lower-crowd position plus its relative
separation, including any fixed offset and documented sign convention. Do not
hold upper crowd fixed in world space when lower crowd moves.

Build a joint/parent table before coding transforms. Establish which physical
members contain boom-swing, lift, trunnion, and yaw pivots from the images and
records; the order of rows above is not a complete serial joint chain. Record
uncertain parentage and ask a focused question if it changes the mechanism.
Use pivot nodes distinct from mesh centers so rotating a joint does not make
its attachment point drift.

Draw hydraulic cylinders between their two attachment points so they articulate
with the mechanism. Initially joint angle may drive cylinder appearance. Do not
claim a stroke-to-angle relationship until pin geometry is known. No automatic
level-keeping relationship between boom lift and joint lift is established.

Use labels for unconfirmed signs/zeros. If reference markers are shown, distinguish
COR, physical target plate, WP mark, and pin. Omit unlocated markers or label their
placement as estimated; do not merge them into a single target point.

## Build sequence

1. Inspect repository/tooling and images; prepare the joint/parent table and
   parameter provenance list. Resolve only ambiguities that block correct motion.
2. Build the reference pose and cameras, matching proportions against the side,
   end, and angled views. Show uncertain pivots for owner review.
3. Add each joint separately, then coupled motions and the crowd relationship.
   Add cylinder visualization after the relevant attachment points are defined.
4. Add labels, controls, reset, and the assumption display. Finish the local launch
   path and perform functional and visual checks.

Proceed with clearly labeled visual estimates where practical. Do not repeatedly
ask for dimensions already recorded, or present estimates as calibrated geometry.

## Acceptance checks and handoff

Record actual checks, implementation/configuration revision, and limitations:

- Open the viewer locally and inspect side/end/angled poses against the images.
- Exercise every joint individually; its pivot stays fixed in its parent frame
  and only the appropriate descendants move.
- Confirm boom lift raises, joint lift tilts rearward, and their controls remain
  independent. Check boom-swing/yaw opposite feedback directions.
- In the aligned level pose, increasing X-slide by 0.30 m produces approximately
  0.30 m rearward reference displacement, with other joints fixed.
- At nonzero pitch, Z-slide translates along its tilted local axis. Roll moves
  the mast without rolling the Z-slide backbone.
- Mast slide carries both crowds; lower crowd carries upper crowd when upper
  relative travel is fixed; upper-only travel leaves lower crowd unchanged.
- Screw and drill steel remain coaxial through pitch, roll, and crowd motion.
- Check combined poses and display-range endpoints for detached geometry or
  nonfinite transforms. No collision-free machine envelope is claimed.
- Reset restores the complete reference state reproducibly; camera presets and
  controls work after resizing. Check rendering remains usable on the laptop.
- Add focused kinematic tests for these relationships and frame/sign conversion;
  report browser checks separately from automated checks and build success.

Deliver source, configuration/provenance, launch instructions, representative
screenshots, checks performed, and remaining geometry questions. Source review,
visual plausibility, and model tests do not establish machine accuracy or hardware
validation. Update README's current position once implementation is delivered.

## Suggested Codex model and starter prompt

Recommendation for this build: GPT-6.1 Sol at High reasoning effort. This is an
engineering judgment for a task combining image interpretation, articulated
geometry, and code. Use Medium for later small cosmetic changes. Increase to
Extra High for a persistent coupled-transform problem if needed. This brief does
not authorize parallel agents.

The recommendation is consistent with the official
[model and effort guidance](https://learn.chatgpt.com/docs/models), consulted
November 2, 2026; available selections depend on the client/account.

Paste into the implementation chat in this workspace:

> Build the standalone TD3 articulated model described in
> docs/requirements/standalone-3d-model.md. Read AGENTS.md, README.md,
> docs/GEOMETRY.md, and the linked image references first. Implement and verify the
> first version, with clearly labeled estimates and a practical Windows launch
> path. Keep PLC/HMI source and hardware untouched. Ask only about mechanical
> ambiguities that prevent a representative motion hierarchy. Deliver a runnable
> viewer and report checks performed and unresolved geometry.
