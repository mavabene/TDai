# Machine geometry and GPS reference conventions

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

## Required treatment of derived results

State the frame, origin, units, physical reference point, attitude, angle signs,
and product/operation for every calculation. Label simplifications. Trace the
specific conversion helper rather than inferring mathematics from `WORLD`, `TD`,
`WP`, or `mast` in a name. Existing comments conflict in places; see the
[assessment](ASSESSMENT-2026-10-27.md). The outstanding numerical and interface
definitions are tracked once in [OPEN_QUESTIONS](OPEN_QUESTIONS.md).
