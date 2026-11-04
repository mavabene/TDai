# Dimension and ET Plumb overlays

The **Show pivots & slides** checkbox controls gold points and gold slide
highlights. Steel guides remain visible with the annotations off. Only actuator axes and slide reference points
are selectable; cylinder ends and pendulum points are omitted. With points off,
a changed actuator's point and slide highlights appear for two seconds after the last coordinate
change. Hidden points cannot be picked. With dimensions enabled, select two
visible points for live ground-plane distance, signed plumb rise and inclination.
The reference COR height is 232.47 cm; see DRAWING_GEOMETRY.md for the exact pose,
known-range checks, and WP/COR axial relationship.

Enable Show dimensions to draw plumb COR/pin lines to the ground plane and see
their heights in cm. Click an actuator to highlight it and display its length
and signed elevation angle from world horizontal. Clicking also enables dimensions.
The controls/readouts occupy a compact card at the model viewport's top right.
CAD-style arrowheads, dimension lines, extension leaders and labels follow the
selected actuator on screen as you orbit/zoom, while numerical angles remain
relative to world horizontal. COR and pin plumb-height leaders are drawn beside
their world positions. Hover the compact readouts for fuller measurement details.
For hydraulic cylinders the line is pin-to-pin, using estimated attachment points.
Other parts show explicitly named assembly spans/axes, not invented cylinder
lengths. Slides show a zero-to-carriage travel dimension and their current position
in cm, rather than a generic block height. Upper crowd zero is the gap between
the touching crowd bearing-block edges. See DRAWING_GEOMETRY.md for live upper/
lower crowd rail limits. Numeric outputs
are measurements of this estimated model, not measured machine calibration.

Enable ET Plumb mode to show two amber world-vertical screw-top stubs on either
side of the fixed North–South line through the
boom-swing pivot. Forward (+X) is North; right (+Y) is East. Their North/South
station follows COR; East/West locations remain symmetric about chassis Y=0.
If COR is laterally displaced, the panel warns that these fixed-centerline
locations are placement targets rather than the current drill axis.

Stance comes from the ten listed size rows in the owner's drawing. Each row has
a pin height at 3-inch minimum reveal and a fixed full screw-to-screw stance.
For pin height H in inches, required reveal is `3 + H - row_min_pin_height`.
Keep rows with reveal in 3–15 inches; select the reveal closest to 9 inches,
breaking exact ties toward the earlier/smaller row. Display half and full stance,
actual reveal, and row number (not a manufacturer part number). No interpolation
or extrapolation is used. Outside the 40.93–114.94-inch pin-height envelope no row
is selected and markers are hidden. This replaces the incorrect straight-20°-leg
formula, which did not account for the new product's lower bends.

The pin is 101.6 mm above the cap WP along the cap's local up axis. WP coincides
with COR only in the aligned assembly pose. Pin height is
computed after pitch/roll, so the vertical offset is smaller when tilted. The
8.53-inch socket/top-of-leg dimension and ±1.5-inch adjustments are not added
again to the tabulated height/stance relation. Screw tops refer to the horizontal
top rim plane at the selected reveal height. Upper members can be inclined and
bent; the ground-screw ends are plumb, as clarified in "Clarify ET Plumb".

The cap is attached to the lower-crowd holder. Turning ET Plumb on sets the model
mast slide to 195 cm and lower crowd to 160 cm; WP then coincides with COR. Both
controls remain adjustable afterward. The Align holder button restores those
positions. Notes beside both controls show the fixed source references and the
position required now to realign, accounting for the other slide's movement:
`required mast + current lower crowd = 195 + 160 cm`, or vice versa.

The mast reference is `MAST_SLIDE_COR_POS` in Dimensions.gvl (hardcoded 195 cm).
Lower crowd uses the declaration default `LOWER_CROWD_COR_POS := 160` in
DUTs/sPersistent_1.dut; HMI can change the rig's persistent value. This is the
owner-selected model assumption, not an inspected live NVM setting. Source root
is the 530v2 StandardPLC Application identified in LIMITS.md. Drawing offsets
map the reference pose into the estimated model geometry; no calibration is written.

Moving either slide moves the mounted cap; WP-to-COR separation and actual pin
height update. Discrete stance/reveal selection uses that actual cap pin height.
Screw locations stay symmetric about the chassis N–S line at the cap's N/S station.
Cap/socket/bend shapes and holder mounting geometry are schematic. Leg outlines
adapt to connect endpoints; they do not validate component lengths, insertion,
or crimping fit. They draw through the machine for visibility. The cap remains
visible with ET Plumb on even when no listed size fits; legs/screws hide then.

No PLC/GPS connection or machine motion occurs. Mode entry changes only this
model's reference pose; there is no automatic installation/placement sequence.

Z-slide input changes update cap pin height, select the fitting listed size again,
and rebuild screw positions and leg outlines immediately. If no size fits the
new height, a compact out-of-range message replaces the stance and the screw/leg
outlines hide; the cap remains visible. There is no extrapolation beyond the
drawing table. The South direction label reads SOUTH / REAR.
