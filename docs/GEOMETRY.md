# Machine geometry and GPS reference conventions

November 3 owner-supplied SolidWorks dimensions supersede the older nominal
135/135 cm arm assumptions for the standalone model. Drawing constraints,
reference poses, explicit mm-popup conversion, and inferred offsets are maintained
in [simulator drawing geometry](../simulator/DRAWING_GEOMETRY.md). The 118.38 cm
boom link and separate joint/yaw/pitch/COR offsets replace the earlier simplified
two-arm chain. These model changes do not modify PLC geometry constants.
The subsequent owner-confirmed level COR reference and WP/COR axial relationship
are maintained in the same simulator drawing-geometry record, with range checks.
Working v0.4 also reconciles crowd bearing-edge references and centralizer/chuck
heights with 530v2 source, and applies its coupled geometric rail-top limit. The
effective rail extent follows active source arithmetic; physical endpoints and
the owner's stacked-near-top expectation remain unresolved there.

Status: maintained interpretation of [GEO-06](SOURCE_BASELINE.md), revision 0.6,
dated October 27, 2026. Statements described below as “recorded physical context”
were marked owner-confirmed in that supplied note. They are carried forward as
the supplied physical model; this assessment did not remeasure or independently
validate the rig. Code observations are identified separately.

The original note remains unchanged. New evidence should update this maintained
record with provenance rather than silently rewriting the original or treating
all software comments as physical facts.

## Machine and product references

The supplied context describes a diesel-powered hydraulic rig installing ground
screws approximately 1.5–2.5 m long for solar foundations. Most foundations use
two battered legs; some motor foundations have a third leg and require different
intermediate installation geometry. Do not apply two-leg geometry universally.

PNEZD is point identifier, Northing, Easting, elevation, description. The
description can encode installation parameters and is not merely a label.
Datum, elevation reference, coordinate precision, and the complete description
grammar still need an interface specification.

| Term | Meaning |
| --- | --- |
| Geometric workpoint | Intended intersection of the battered leg axes |
| Target-plate WP mark | A physical mark on the GPS reference plate / truss cap holder |
| COR | Center of Rotator; generally associated with the geometric workpoint in the reference arrangement |
| Pin mark | A separate physical mark on the target plate used for Earth Truss referencing |
| Design target | Original PNEZD reference for the finished foundation |
| Effective target | Target after the currently active PLC-supplied adjustments |
| GPS-configured reference | The reference point inferred from GNSS/attitude and configured geometry |
| Actual target plate | The physical plate carried by the lower crowd; it can move relative to the GPS-configured geometry |

Never use an unqualified `WP` to equate all of these points. A variable containing
`WP` must be traced in its actual context.

| Product convention in supplied context | PNEZD reference | GPS calibration mark | Reference arrangement |
| --- | --- | --- | --- |
| SI | Workpoint/COR | WP mark | Plate WP mark aligned with COR; intended references coincide in this pose |
| Earth Truss | Pin | PIN mark | Plate WP mark aligned with COR; pin remains distinct and is positioned to the PNEZD target |

The note records an intent to use pin references for future products. This does
not retroactively change SI code/data conventions. Product-specific offsets and
numerical slide positions are still needed for calculations. Physical alignment
is a calibration pose, not a permanent rigid coincidence throughout screw driving.

## Frames, directions, and units

Recorded machine axes, viewed standing behind the rig looking forward:

| Axis | Positive | Negative |
| --- | --- | --- |
| X | Forward along the machine | Rearward toward mast/operator |
| Y | Right | Left |
| Z | Up | Down |

Forward/right/up is left-handed. With the machine level and facing North,
X/Y/Z are North/East/Up. Facing South, they are South/West/Up. A mechanical joint
angle, compass heading, and mathematical rotation need separate sign definitions.

For a level machine only, with machine heading `H` clockwise from North and a
displacement `(x,y,z)` expressed in these machine axes relative to a stated origin:

```text
delta_N = x*cos(H) - y*sin(H)
delta_E = x*sin(H) + y*cos(H)
delta_Z = z
```

Use consistent linear units and degree-aware trigonometry for degree inputs.
These equations omit pitch/roll. They are not a complete targeting model and do
not turn target-plate GPS offsets into chassis-frame offsets automatically.

Recorded GPS interface interpretation after vendor decoding:

- X/Y align with the target plate rather than necessarily with the chassis.
- Z is gravity-vertical/plumb, positive upward. Do not rotate it with mast
  pitch/roll as if it were a rigid plate-frame Z coordinate.
- A positive translational offset means the reference must move in the positive
  GPS-axis direction. It is a movement-to-target quantity.
- The horizontal projection/attitude convention for X/Y with a tilted plate is
  unresolved. Positive heading-error physical sense is also unresolved. A code
  comment in P-TARGETS is evidence of a software assumption, not physical proof.

P-TARGETS divides GPS translation offsets in mm by 10 for cm-based geometry.
Its actuator linear positions are in cm, angles in degrees. Other vector helpers
and PNEZD adjustments use mm. Never impose one unit on every geometry variable.
The HMI's absolute-heading declaration says clockwise from North; that does not
settle the sign of heading *error*.

## Positioning chain and motion signs

```text
chassis boom-swing pivot
  -> boom-swing arm -> yaw pivot -> yaw arm + X-slide reach
  -> pitch-supported Z-slide backbone -> travelling rotator
  -> rolling mast -> lower crowd -> target plate
```

Recorded physical context:

- Boom-swing pivot to yaw pivot is nominally 135 cm. At zero it reaches rearward
  along approximately -X. Positive boom-swing feedback swings this arm right.
- Yaw pivot to drill-rod line at zero X-slide is nominally 135 cm and also reaches
  rearward at the aligned zero pose. Increasing yaw feedback swings it left.
  Boom-swing and yaw therefore have opposite positive rotation directions.
- The aligned, simplified two-arm chain reaches approximately 270 cm rearward
  of the boom-swing pivot. Small lateral offsets are omitted. This is not a full
  3D position of COR, pin, or workpoint.
- Increasing X-slide position lengthens the rearward reach over approximately
  30 cm. In the aligned geometry, positive slide travel moves the reference in
  GPS -X. A positive GPS X movement-to-target offset therefore calls for a
  decrease in X-slide position if that slide alone provides the correction.

For that aligned pose, with other joints fixed:

```text
delta_reference_x_gps_cm = -delta_x_slide_position_cm
```

Thus increasing X-slide from 0 to 30 cm moves the reference -300 mm in GPS X.
For a fixed target, the reported movement-to-target X offset increases by 300 mm.
Do not apply this full one-to-one projection to arbitrary pitch/roll poses.

Code correspondence: P-DIMS declares nominal 135/270/135 cm lengths; P-INIT can
assign geometry for machine configuration. P-TARGETS uses
`YAW_PIVOT_TO_DRILL_ROD + X-slide feedback` and explicitly corrects yaw sign.
Declared dimensions are not measured per-rig calibration.

## Z-slide, pitch, roll, and antennas

The pitch backbone supports the Z-slide backbone. The rotator travels along that
backbone. The rotator rolls the mast, lower crowd, and target plate about COR;
**it does not roll the Z-slide backbone**. Pitch tilts the entire supported
assembly, including the Z-slide backbone and everything downstream.

Z-slide travel is vertical when upright. When pitched, it has coupled horizontal
and vertical components. Translation along that slide, roll of the mast, and
pitch of the entire assembly are three different motions.

GNSS antennas are mounted at the top of the Z-slide. The plate is downstream of
mast/lower-crowd travel. Antenna position and actual plate position are different
quantities. Exact pivots, zero poses, pitch/roll signs, and antenna/plate offsets
are still needed for a complete 3D model.

## GPS geometry and PLC target adjustments

Recorded context says the GPS applies its configured attitude/reference geometry
to antenna observations and provides target-plate movement-to-target and heading
offsets. It does not independently track antenna-to-plate geometry changes caused
by mast or lower-crowd motion. Consequently, on-target status is meaningful only
with the active reference geometry, operation, and target adjustment identified.

Selected PLC adjustments support intermediate third-leg positioning and
assembly/crimping compensation. They can change the effective target while
preserving the intended finished foundation location. They must not be assumed
to continuously compensate every screw-driving state.

P-ADJUST sums product/operation adjustments, transforms relevant vectors, and
adds the assembly-only mast/lower-crowd correction. Its axial correction is:

```text
delta_mast_mm = 10 * ((pNVM1^.LOWER_CROWD_COR_POS - lower_crowd_position_cm)
                   + (MAST_SLIDE_COR_POS - mast_slide_position_cm))
```

The code then converts that mast-frame vector using its heading/pitch/roll
helpers before combining world-frame adjustments. P-GPS-CAN packs outgoing
adjustments and includes vendor-specific conversion branches. This describes
implementation structure, not a verified transform or transmitted-byte contract.

## Supplied visual references

The owner also supplied [five actual-machine photographs](../AI%20info/machine-images/2026-11-02-actual-machine/README.md)
on November 2: scale reference, side, front end, front right corner and front left
corner (owner's view labels). These support visual proportions and component
placement, not measured geometry. Multiple rigs appear; exact configuration and
relationship to the model's selected 3.2 profile remain unverified.

On November 2, 2026 the owner supplied six CAD screenshots for machine reference
and a future standalone articulated 3D model. The [image index](../AI%20info/machine-images/2026-11-02/README.md)
preserves five unique images (duplicate attachment 03 removed at owner request) and records visible CAD
measurement labels and their limitations. They add visual context; they do not
supersede the physical conventions above or establish calibrated pivot coordinates.

Owner clarification on November 2, referring to the
[side view](../AI%20info/machine-images/2026-11-02/td3-side-view.png):

- The cylinder nearest the tracks, approximately 30 degrees above horizontal in
  the pictured pose, is the boom lift cylinder.
- The next cylinder above it, approximately 35 degrees above horizontal, is the
  lift cylinder the owner called "join lift" (source actuator name `JOINT_LIFT`;
  the naming correspondence is provisional).
- The pitch cylinder connects the X-slide to the top of the Z-slide, approximately
  80 degrees above horizontal in this pose.
- The X-slide cylinder is not very visible in this view.

These angles describe identification in the pictured pose, not joint zero angles,
travel limits, or calibration. The owner subsequently confirmed that the horizontal
stacked guide/carriage below the pitch-cylinder foot and above the upper boom
linkage is the X-slide guide, and that the Z-slide support and pitch-cylinder base
travel together along it. Exact guide members,
pivot centers, and cylinder attachment coordinates have not been measured.

### Owner-confirmed motion and assembly identification, November 2

The following additional physical context was supplied for the standalone model;
it is not a runtime observation or a verification of PLC feedback conventions.

- Extending the boom lift cylinder pivots the boom lift upwards.
- Extending the joint lift cylinder tilts the trunnion toward the rear of the
  machine, tilting the X-slide. Boom lift and joint lift move independently and
  are operated infrequently. The owner subsequently used "joint lift", resolving
  the earlier "join lift" naming ambiguity.
- The mast is the long red lattice body in the supplied views.
- The white Z-slide member, visible projecting above the red Z-slide backbone,
  slides up/down inside that backbone and carries the assemblies rearward of it
  along with it. "Rearward" identifies the carried assemblies, not an additional
  rearward translation caused by upright Z-slide travel.
- Upper and lower crowd travel along the rear edges of the mast on the gray
  guides. Upper-crowd travel is relative to the lower crowd: moving the lower
  crowd with the upper crowd not engaged carries the upper crowd with it;
  engaging only the upper crowd moves it toward or away from the lower crowd.
  A model must therefore compose lower-crowd travel and upper-crowd relative
  travel rather than treating both as independent absolute mast positions.
- The lower crowd carries the lower rotary, which turns the ground screw.
  The upper crowd carries the upper rotary, which turns the drill steel.
  The drill steel passes through the hollow screw so the drill bit can advance
  slightly ahead of the screw during insertion.

The white moving Z-slide member clarifies the earlier functional description of
the rotator travelling along the backbone; it must be represented as a moving
member carrying the downstream assembly. The owner also confirmed that mast slide
moves the entire red lattice mast through its support at the rotator, carrying
both crowds with it. Crowd travel remains relative to that moving mast, with
upper-crowd travel additionally relative to the lower crowd as described above.
Exact pivot locations, strokes,
limits, engagement/holding behavior beyond the examples above, and signs of
sensor feedback remain unverified; do not infer them from cylinder extension.

## Required treatment of derived results

### ET Plumb model inputs supplied November 2

The [cap detail and stance drawing](../AI%20info/machine-images/2026-11-02-et-plumb/README.md)
support the requested standalone overlay. Cap detail shows pin 101.6 mm (4 in)
above WP/COR along the cap centerline, legs at 20 degrees from that centerline,
and an average top-of-leg reference of 216.8 mm (8.53 in) with plus/minus 38.1 mm
(1.5 in) adjustment. Diagram dimensions in brackets are inches; other cap-detail
values are mm. The stance drawing uses inches. Owner requested machine readouts
in cm, stance in inches and screw tops at 9 in (228.6 mm) above the ground plane.
Owner requested fixed East/West symmetry about a North/South chassis centerline
through the boom-swing pivot. Forward=North is the proposed initial heading.

Correction from the owner and "Clarify ET Plumb" conversation
(`01a19de1-a3fc-7883-a240-e352ff6a0c24`): new-product ground screws are plumb.
Inclined upper members bend into vertical lower ends; their screw-axis stance
must not be calculated as straight 20-degree lines intersecting WP. The bent-leg
assembly drawing is preserved with the cap/stance references. Owner selected
actual listed size rows with resulting reveal, superseding fixed 9-inch tops.
Nine inches is now the preferred reveal, not a constraint for all pin heights.
For each listed row, reveal (inches) is 3 + actual pin height - row minimum pin
height; accept 3–15 inches and choose the row closest to 9. Stance is the listed
full spacing and each E/W offset is half. No interpolation or extrapolation.
Physical pin position follows cap attitude; its plumb height is not always COR
height plus 101.6 mm when tilted. These are model rules, not machine-code behavior.

November 2 standalone-model correction: the owner reported that the displayed
pitch angles were backwards. The model's pitch rotation was reversed from positive
to negative render-Z rotation for a positive control value. With the model mapping
(machine X, Z, Y), positive pitch now tilts the supported local-up axis toward
machine +X in the aligned pose. This is owner feedback on the visual model,
not an independent verification of PLC inclinometer decoding or sensor mounting.

State the frame, origin, units, physical reference point, attitude, angle signs,
and product/operation for every calculation. Label simplifications. Trace the
specific conversion helper rather than inferring mathematics from `WORLD`, `TD`,
`WP`, or `mast` in a name. Existing comments conflict in places; see the
[assessment](ASSESSMENT-2026-10-27.md). The outstanding numerical and interface
definitions are tracked once in [OPEN_QUESTIONS](OPEN_QUESTIONS.md).

ET Plumb cap placement, November 2: the owner's latest instruction supersedes
the interim fixed-COR target outline. The cap mounts on the lower-crowd holder.
At mast slide 195 cm (`MAST_SLIDE_COR_POS` in Dimensions.gvl) and lower crowd
160 cm (declaration default `LOWER_CROWD_COR_POS` in sPersistent_1.dut), its WP
aligns with COR. Owner selected 160 cm for now; actual persistent rig calibration
may differ. Mode entry sets that model pose once, then both slides remain
adjustable. Their axial motions compose: departures from the reference sum to
the cap's WP displacement along the mast. Cap/socket/bend/mount shapes remain
schematic, and no physical component fit or calibration is established.

November 3 photo clarification: the black GPS antenna arms attach near the top
of the moving Z-slide, projecting to either side. The owner corrected the interim
simulator mast mounting; the mast cap remains. See the
[GPS-arm photo](../AI%20info/machine-images/2026-11-03-gps-arms/README.md).
The simulator now parents antenna arms/pucks to Z-slide, so they follow its
translation and pitch but not mast slide/roll. Shape/spacing remain estimates.
