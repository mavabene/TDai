# Working model: dimensioned geometry and pivot measurement

Owner authorized the update after confirming cm and camera-independent horizontal
ground-plane distance. Source: nine screenshots under
`AI info/machine-images/TD_Dims_per_SldWks/`. The explicit 1429.29445384 mm CAD
popup is converted to cm. Maintained constraints, frame, reference pose, angle
mapping and assumptions: [DRAWING_GEOMETRY](../../simulator/DRAWING_GEOMETRY.md).
Only the active `simulator/` copy changed; stable v0.1 viewer and portable ZIP
retain their recorded SHA-256 identities.

Implemented: dimensioned boom link, separate boom/yaw/pitch/COR offsets, pivot
ground heights, pendulum reference and track width/height/spacing. Replaced the
misleading 135/135 cm arm assumptions. Initial reference is boom 25°, joint 28°,
Z-slide 151.75 cm; the model mast is plumb at pitch/roll zero. Some control-to-
drawing offsets and the boom-lift/swing-axis offset are inferred, as recorded.
Undimensioned cylinder mounts, bodywork and mast/crowd envelope remain estimates.

Gold pivot-center markers and slide guides show movement locations. With
dimensions enabled, A/B center selection produces live CAD leaders for full
horizontal distance, signed plumb vertical distance, direct span and inclination
from A toward B. Third click starts a new pair; explicit clear button is provided.
Cylinder mounting markers carry an estimated-mount label. Pair centers move with
their assemblies; measurements use world coordinates rather than screen pixels.

Validation: `node build.mjs` succeeded. `node --test tests/*.test.mjs` passed 29
tests, including reference drawing closure, ordered 3D pivot measurements,
motion signs, slide composition, plumb reset, ET size updates and portable asset
equality. Joint-pivot ground height closes within 0.05 cm of the rounded drawing.
Working sharing ZIP and source-hash manifest refreshed. Stable viewer SHA-256
`36F583C0C925369DAF48062B7BAAE82069967E88EC89F8828C5117FBB01FFBE5` and ZIP
`0287395DD1BAD70C57D9D6C80E52600F3C1B80E2C7C88BA1F1597CCC280ACF7E` confirmed unchanged.
Browser automation initialization timed out, so no new visual or interactive
browser verification is claimed. No PLC source changes or machine tests occurred.

## Actuator markers and owner-confirmed COR reference

Follow-up owner request: toggle the actuator markers, reveal a moved axis with
markers off, remove cylinder markers, include all five slides, and close the
level-reference COR height to exactly 2324.7 mm. Current geometry and the WP/COR
relationship are maintained in DRAWING_GEOMETRY.md, superseding the earlier
rounded-angle closure above. The previous height was 2324.62838166 mm; using the
dimensioned heights gives link inclination 29.60398666793 degrees at boom 25,
while preserving the 118.38 cm link and swing/yaw spacing.

The 11 markers follow boom swing/lift, joint lift, yaw, pitch, rotator, X/Z/mast
slides and lower/upper crowds. Cylinder-end and pendulum markers are removed.
With markers off, only changed actuator coordinates trigger their point for two
seconds after the last change. Idle focus/updates do not reveal markers; hidden
markers are excluded from ray picking. The toggle clears an existing pair.
Slide markers are carriage/reference points rather than rotational pivots.

Validation: 33 automated checks pass. The reference COR is exactly 2324.7 mm and
the level Z-slide limits (2/167.5 cm) produce 827.2/2482.2 mm COR heights.
WP/COR coincidence at mast 195/lower crowd 160 cm is checked over 27 Z/pitch/roll
combinations; 243 combinations also check signed axial WP displacement across
mast/lower-crowd limits. Tests cover marker membership, parent motion, hide/show,
two-second expiry/retriggering and exclusion of drill-rotary speed changes.
This is model verification, not a machine calibration or hardware test.

## Working v0.4 — source crowd datums, rail stops and slide annotations

Owner requested touching crowd edges at upper zero, slide annotation behavior
matching pivots, a checkbox, and a check of crowd/mast/ground geometry. The
follow-up clarified the coupled upper-crowd top calculation and required the
lower crowd to remain on the guide at its bottom end. Maintained source paths,
coordinate references, calculations and unresolved physical dimensions are in
DRAWING_GEOMETRY.md's crowd-and-mast section. The source datum corrections replace
the arbitrary -65 cm lower placement and 160 cm upper separation. COR height and
exact 195/160 WP coincidence are retained.

Implemented in the active working copy: shared pivot/slide checkbox and transient
gold highlights over persistent steel guides; actual zero-to-carriage slide
dimensions; source-length bearing sleds and drifter; source centralizer/chuck/
drill references; source-based effective rail envelope; lower minimum 37 cm;
and coupled top limits retaining the manual-branch 5 cm clearance. Upper zero is
an owner-requested preview below the source 1 cm command minimum. Ordinary crowd
edits hold the other coordinate fixed; alignment/profile presets trim upper if
necessary. A floating-point boundary note found in browser review was corrected.

Validation: final node build.mjs exited successfully, then all 40 node tests
passed. Tests include touching edges over combined tilt/travel, centralizer/chuck/
drill formulas across slides, source top-clearance arithmetic, live crowd limits,
both profile bottom stops over Z/mast/attitude changes, and gold slide visibility.
Browser verification used the in-app browser at http://127.0.0.1:8313, including
the laptop layout and side view. Direct-file startup and portable asset equality
were automated checks; Chrome's automation endpoint was unavailable.

Browser observations: lower command -1 m clamps to 0.37 m. At lower=2.70 m an
upper command of 10 m clamps to 3.035485 m with displayed 5.0 cm clearance. At
lower=0.37 m, upper reaches 5.365485 m; ET entry realigns lower=1.60 m and trims
upper to 4.135485 m. The final exact-boundary alignment note reports 160 cm
within range, with WP-to-COR 0.0 cm. The final reference preview shows upper=0,
COR 232.47 cm and gold pivots/slides controlled by the checkbox.

Remaining limits: the active source still leaves 308.5485 cm above the stacked
pair at lower=270/upper=0. Source rail comments and active arithmetic disagree;
physical endpoints need confirmation. Low independent Z/mast combinations can
cross the flat ground, as predicted by the source centralizer formula. Neither
machine-state interlocks, automatic E-stop response nor ground collisions are
executed. No PLC/HMI source was changed and no machine test occurred.
