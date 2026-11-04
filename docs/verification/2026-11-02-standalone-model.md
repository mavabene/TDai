# Standalone TD3 visual model v0.1 — November 2, 2026

Scope: first local articulated model following the
[build brief](../requirements/standalone-3d-model.md). Physical context is owned
by [GEOMETRY](../GEOMETRY.md). This viewer does not execute PLC code; no PLC/HMI
source, binary, library, controller, or machine was modified or operated.

## Implementation identity

Source under `simulator/`; geometry revision `TD3 visual model 0.1` in config.js.
Three.js 0.180.0 pinned in package.json and pnpm-lock.yaml. JavaScript ES modules
instead of TypeScript avoid a compiler dependency. See
[validation source hashes](../../simulator/validation-source-hashes.json) for the
exact application, configuration, launcher, tests and dependency lock checked.
Image references are the five owner-supplied November 2 CAD screenshots.

## Checks actually completed

- Eight Node.js kinematic tests passed. They cover the left-handed machine-frame
  mapping, nominal aligned reach, 0.30 m X-slide displacement, boom-swing/yaw signs,
  independent lift motion, pitched Z-slide travel, backbone independence from
  roll, mast/crowd composition, coaxial tools, finite endpoint poses, and reset.
- The first run exposed quaternion-angle numerical noise (approximately 5e-8 rad)
  in a zero-change assertion. The check now compares the unchanged backbone world
  matrix directly. All eight tests passed after this test correction.
- `node build.mjs` assembled the offline assets; no CODESYS compile was performed.
- The local page and its modules loaded successfully in the browser. Runtime
  assets use local dependency paths rather than CDN. A delayed PowerShell HTTP
  probe also completed: page, app.js, Three.js module and side-reference image
  each returned HTTP 200.
- In-app Chromium browser, 1280 x 720: observed the rendered reference pose and
  compared side and angled appearance with supplied images. Tested all 13 numeric
  controls in a combined pose; visible paired slider readouts updated. Exercised
  side, end, top, isometric, fit, axes toggle, and reset. All joint values reset to
  zero. Captured browser diagnostics contained no warnings/errors.
- [Reference screenshot](../../simulator/screenshots/isometric.png) saved. The
  model is recognizable and articulated; visual review is qualitative, not a
  measurement of pivot accuracy.
- PowerShell launcher syntax and dependency availability checked. It can find
  this laptop's bundled Node runtime; double-click/OS browser launch remains an
  owner check. Preview was served directly with Node during browser testing.

## Limits and next action

Visual revision 0.2: owner requested photo/CAD-based proportions, simple red body
and logo, and a 6-foot person. Revised enclosure/tracks/support elevations and
added approximate Ojjo lettering and an exact 1.8288 m scale figure. See the
simulator README for dimension provenance. Existing source ranges and controls
are retained. Pitch-to-rod offset now sits within the 1.35 m yaw reach; reference
tests check both rotator and drill-axis reach. No PLC files changed.

Machine envelope and vertical offsets remain estimates. Source pose-specific
ground/rotator heights were not imposed on unmatched reference poses. The figure
sets a known model-unit scale, not a verified physical machine height.

Owner pitch correction: reversed the model pitch rotation sign after the owner
reported it backwards. Command range remains -6 to 80 degrees. Added a regression
assertion that positive pitch tilts the local-up axis toward machine +X at the
aligned pose. Rebuilt the viewer and sharing ZIP and refreshed source hashes.
This is a model correction; PLC source and sensor decoding are unchanged.

### Source ranges, continuous rotaries and sharing (same day)

Owner selected machine family 3, version 2, displayed as 3.2. Eleven positional
controls now use 530v2 axesInit initialization command ranges; lower crowd uses
the version-2 machineInit minimum of 37 cm. Full source member paths, units and
exceptions are maintained in [LIMITS.md](../../simulator/LIMITS.md). axesInit SHA-256:
`7C58ACDBA8123B55EB004314CF39B692228C6A9E419DDCB96DE85EB23E743A38`.
The requested profile is not evidence of what runs on a rig.

Owner clarified that both rotaries rotate continuously in either direction.
Their controls now set signed demo RPM; animation integrates angle without a
position stop. Stop rotaries zeros both speeds, while reset also restores angle.
Demo RPM is not a source-derived hydraulic speed model. Drawing offsets preserve
the reference pose while source-coordinate readouts include nonzero minima.
Slider increments support the source's 0.5 cm endpoints exactly.

Twelve automated tests pass, including source command-range comparison and
bidirectional rotary wrap/stop mathematics. Browser check showed default 3.2
profile, source range labels and both RPM controls; +20/-25 RPM inputs and Stop
rotaries updated correctly. [Browser evidence](../../simulator/screenshots/profile-3.2.png).
Full offline-file launch remains subject to the earlier automation URL limitation.

Portable [sharing ZIP](../../simulator/releases/TD3-model-3.2.zip) contains only
the built viewer, style, two reference images, recipient instructions, range notes
and Three.js license. Extract before opening index.html; no install required.
Archive entries were inspected and viewer bytes checked against the build.
No upload or publication was performed. Geometry accuracy and runtime limits are
still unverified; state-dependent source restrictions are not emulated.

### Direct-file startup correction (same day)

The owner reported a blank model/control area when opening
`file:///C:/Users/jcheney/Documents/Codex/TD3ai/simulator/index.html` in Chrome.
The original static module entry did not support that launch path; only HTTP
startup had been checked. This supersedes the original launch/package behavior
described above, without changing kinematics or geometry.

Added esbuild 0.25.10 as a pinned development dependency. The build now emits a
classic viewer.js with all JavaScript dependencies bundled, and copies local
reference images. Both the source-folder index and portable dist/index can be
opened from disk. Launcher rebuilds and opens the file rather than starting a
server. An inline error handler covers script-load failures and a startup timeout.

Ten tests pass: the original eight plus classic-script parsing/entry checks and
portable asset consistency. The bundled entry rendered over localhost in the
in-app browser, all 13 controls were present, boom-lift input/reset worked, and
captured warnings/errors were empty. Saved
[startup correction preview](../../simulator/screenshots/startup-fixed.png).
Direct-file browser automation was rejected by the browser URL policy, which
allows HTTP/HTTPS only. No browser policy was bypassed. Direct-file operation in
the owner's Chrome remains an owner refresh check; static checks establish that
the entry no longer requires module loading or remote resources.

The dependency install reported ignored esbuild lifecycle scripts; its packaged
native binary nevertheless built successfully. Native build required execution
review because sandboxed esbuild ancestor-directory reads were denied. Source
fingerprints were refreshed after this change. No machine source changed.

### Physical-model limits

Mast proportions, lift/yaw/trunnion pivot nesting and all unmeasured offsets are
estimated. Nominal arm dimensions are horizontal projections. Cylinder sleeves
follow their endpoint geometry, with no calibrated stroke-to-angle relationship.
Display ranges are demonstrations and do not establish collision-free travel or
physical limits. Crowd holding dynamics and hydraulic response are not simulated.
The screw flights are simplified rings for recognition, not helical geometry.

Browser drag/pan/zoom and resized-window behavior are implemented through
OrbitControls/ResizeObserver but were not separately exercised in this check.
No performance benchmark, offline network-disconnection test, physical metrology,
hardware validation, GPS simulation, real sensor, or communications test occurred.
The screenshot is evidence of rendering, not machine geometry acceptance.

Next: owner reviews the model's side/end/angled views and individual movements,
starting with lift/trunnion/yaw pivot placement. Correct the parameterization from
that evidence before treating any position readout as physically accurate.

Visual-revision verification: 13 tests passed, including sole-to-crown height
1.8288 m and aligned drill-axis reach. The initial figure test used exact floating
point equality for feet-to-metres and was corrected to a numerical tolerance;
the actual figure bounding-box check passed. Browser side/isometric views were
reviewed at desktop and narrow layout sizes; no browser warnings/errors were
captured. Screenshot: simulator/screenshots/red-model-scale-person.png. The
portable sharing ZIP was rebuilt and source fingerprints refreshed. No actual
machine dimensional accuracy, hydraulic behavior or collision envelope is proved.

Measurement/ET Plumb overlay: 17 tests passed, covering signed world-elevation
angles, plumb heights, tilted pin offset, 9-inch reveal, East/West symmetry,
full/half stance and invalid low-COR cases. Browser click selected the pitch
cylinder (159.4 cm / 76.6 degrees in the reference model). Pitching to 20 degrees
changed COR height and reduced the plumb pin offset as expected. Reference model
COR height was 253.0 cm, pin height 263.2 cm; nominal half/full stance 32.98/65.96
inches. These results apply only to the model geometry and selected ground plane.
No machine, PLC or GNSS validation occurred. Side/end/isometric overlays were
visually checked; no browser warnings/errors were captured. The screenshot is
simulator/screenshots/et-plumb-dimensions.png. Detailed definitions/limits are in
simulator/MEASUREMENTS.md. Numerical stance follows nominal 20-degree geometry,
not exact interpolation of the rounded supplied drawing table.

ET Plumb correction: owner identified that screw ends must be plumb and directed
review of the "Clarify ET Plumb" chat. Its supplied bent-leg assembly was inspected
and preserved. The earlier straight-20-degree stance formula and its numerical
stance examples above are superseded; those tests only verified the wrong model.
Owner selected listed sizes with variable reveal. The implementation now uses
10 tabulated pin-height/stance pairs, selects valid 3–15-inch reveal closest to 9,
and draws vertical screw ends. Nineteen tests passed, including each size midpoint,
minimum/maximum table heights and refusal to extrapolate. Cap/leg assembly outline
is being added under the owner's subsequent request; placement clarification is
pending. Exact reference pose and machine geometry remain estimated.

Cap target placement resolved: owner selected cap WP at COR, independent of
lower crowd. Added schematic heart-cap and bent-leg outlines, drawn through the
machine for visibility. COR target pose remains fixed for crowd/mast travel and
follows rotator position/attitude for upstream motions. A regression test checks
this independence. The standalone overlay is not a modeled physical holder fit.

Latest cap placement supersedes the interim independent-COR target: cap is now
mounted on lower crowd, with WP aligned at mast slide 195 cm and lower crowd
160 cm. Source constant and persistent default were traced; the owner explicitly
selected 160 cm. Enabling ET Plumb sets those two model positions once. Subsequent
adjustment remains possible. Notes beside both controls calculate the required
value from the other slide position. Tests now verify physical holder parenting,
reference alignment under tilt, displacement after crowd travel, and realignment
using summed mast/crowd travel. No persistent data or machine source was changed.

Final holder-alignment checks: 21 automated tests passed. Browser mode entry
from 180/190 cm restored 195/160 cm and zero WP/COR separation. Changing lower
crowd to 180 cm remained effective (20 cm separation); mast note changed to
175 cm. Setting mast to 175 cm restored zero separation and lower-crowd note
showed 180 cm. Align holder restored 195/160. Both notes were visible with ET
Plumb enabled. Browser warnings/errors were empty. Screenshot:
simulator/screenshots/et-holder-alignment.png. Reference pin height 263.2 cm
selected drawing row 9, stance 60.35 inches and reveal 10.56 inches. These are
model results with the current estimated COR location, not rig measurements.
The earlier cap-target independence test is superseded by the holder-parenting
and assembly-reference tests. Source fingerprints and sharing ZIP refreshed.

Compact CAD overlay update: moved dimension/ET toggles and short readouts to a
content-sized top-right card in the model viewport. Selected actuator lengths
and world-elevation angles now appear next to the actuator with screen-projected
CAD extension leaders, dimension lines and arrowheads. COR/pin plumb dimensions
have equivalent leaders. Full descriptive readout is available as a hover title;
source/mount estimates remain explicit. SOUTH / MAST changed to SOUTH / REAR.

Twenty-four automated tests passed, including projected CAD leader geometry and
an end-to-end kinematic Z-slide size transition. Browser checked at 1280x800:
Z-slide 0.02 m gave row 9 / 60.35 in stance; 0.20 m gave row 10 / 65.36 in stance
and 10.75 in reveal, with changed screw/leg geometry. At 0.50 m the pin height
was 122.50 in, outside the drawing envelope, and no-fitting-size status replaced
the selection. Restoring Z restored the original row. Screen annotations followed
isometric/side camera changes. Source range/geometry values were not changed.
These are model results, not measured physical motion or accuracy verification.

Final CAD panel check: compact card measured approximately 239 x 136 CSS pixels,
16 px from the top/right of the 930 px model viewport at desktop test size.
Narrow layout also checked. SVG leaders were visible; side/isometric camera
changes reprojected them. Redraw caching avoids rewriting unchanged annotation
DOM during idle rendering; no performance benchmark is claimed. Browser diagnostic
capture was empty. Final screenshot: simulator/screenshots/compact-cad-dimensions.png.

## November 3: Track reset and desert appearance

Owner requested upper rotary +/-200 rpm, a nominal Track Normal reset with mast
plumb, closed mast top with GPS pucks, four-inch screw diameter, and switchable
light brown/translucent-scrub environment. Implemented only in simulator files.
Source selection remains profile 3.2 and 530v2 readable exports. Reset uses
machineInit/StatePositions values, non-GPS X-slide 15 cm, and declared upper-crowd
245 cm despite its disabled Track command. See simulator README for all values,
paths, plumb compensation, and distinction from actual Track state execution.
The old assembly-reference reset remains available. Decorative mast-top GPS
placement is owner-requested and not surveyed Z-slide antenna geometry.

Validation: node --test tests/*.test.mjs: 27 passed, zero failed after rebuilding
viewer.js and dist. New checks cover reset positions/command boundaries,
world-up mast axis, signed 200 rpm integration, 0.1016 m diameter, environment
visibility/color/transparent non-depth-writing scrub, and unchanged ground height.
The first pre-build run had one expected stale portable-assets mismatch; the
rebuilt source and portable entry/bundle match. node build.mjs succeeded.
Portable TD3-model-3.2.zip refreshed; source fingerprints in simulator manifest.
Browser automation timed out twice (documentation initialization and new preview
tab), so no new rendered-image or browser-interaction verification is claimed.
No controller connection, PLC/HMI changes, compile, or hardware validation.

### November 3 GPS-arm photo correction

Owner clarified that the black side arms in the new photo belong to the Z-slide.
Kept the red mast cap and replaced mast-mounted antenna crossbar with two
schematic black braced arms/pucks parented directly to the moving Z-slide.
They follow Z-slide and pitch, independently of mast slide and roll. The new
photo is preserved in AI info/machine-images/2026-11-03-gps-arms; geometry and
simulator README were reconciled. Arm dimensions remain visual estimates.
Build completed and portable sharing bundle refreshed. Source hierarchy confirms
Z-slide parenting. No new browser visual check or hardware test is claimed.

### November 3 first stable build snapshot

The owner requested preservation of the completed first model version before
further work. `simulator-stable-v0.1/` is a complete snapshot of the viewer
source, built files, portable package, reference copies, screenshots, tests and
source-hash manifest, excluding rebuildable `node_modules/`. `simulator/` is the
active editable copy created from the same version. The stable `viewer.js` and
`releases/TD3-model-3.2.zip` are byte-identical to the working copies, with
SHA-256 values recorded in `simulator-stable-v0.1/STABLE_BUILD.md`. The current
working copy test suite passed 27 checks with zero failures after the snapshot.
This establishes a software-artifact checkpoint only; it does not add PLC,
controller, compile, or machine-test evidence.
