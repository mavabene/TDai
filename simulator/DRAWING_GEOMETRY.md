# Working geometry from SolidWorks screenshots

Owner supplied `AI info/machine-images/TD_Dims_per_SldWks` and confirmed cm,
November 3, 2026. This replaces the old simulator 135 cm arm assumptions.
CAD popup units explicitly labelled mm are converted to cm. These are drawing
constraints, not measurements from a rig or encoder calibration.

Reference: level ground at render Y=-1.08 m, chassis N/S centerline through
boom-swing axis; machine +X North/forward, +Y East/right, +Z plumb up. Render
mapping is (machine X, Z, Y). Positive boom swing moves rearward arm right;
yaw feedback has opposite sign. Slide travel stays in source cm coordinates,
converted internally to metres. Side-view distances below are magnitudes.

| Drawing | Constraint in cm |
| --- | --- |
| Boom_Lift_Pivot_To_Ground_Plane | Boom pivot plumb height 86.50 |
| Boom_Lift_Pivot_To_Joint_Lift_Pivot | Center span 118.38; link inclination 29.6° at boom setting 25° |
| Joint_Lift_Pivot_To_Ground_Plane_Distance | Joint pivot height 144.98 at pictured pose |
| Joint_Lift_Pivot_To_Yaw_Pivot | Rearward horizontal offset 23.00 |
| Boom_Lift_Pivot_To_Pitch_Pivot, X-slide 30 cm | Joint-to-pitch horizontal 82.00 and vertical 84.04 (dimension endpoints shown) |
| Pitch_Pivot_To_Rotator_Axis_To_Drill_Axis, Z-slide 151.75 cm | Horizontal 93.32; COR 3.45 above pitch pivot |
| TD3.X_Boom_Swing_Axis_To_Yaw_Axis_Distance, boom 25° | Parallel-axis spacing 1429.29445384 mm = 142.929445384 cm |
| Boom_Lift_Pivot_To_Pendulum_Pivot | Pendulum 29.00 forward and 42.30 below boom pivot |
| TD3_Track_Dims | Track width 40.00, height 66.47, center spacing 185.00 |

Reference slide frame is level at boom 25°, joint 28°. The model uses link
inclination = boom feedback +4.60398666793°, slide-frame attitude = joint - boom -3°,
and pitch zero for a plumb mast at that pose. These drawing-to-control offsets
are model conventions pending encoder calibration. The yaw axis is assumed at
joint-pivot height because no separate vertical offset is dimensioned.
Combining axis spacing, link projection and 23 cm offset infers a roughly 17 cm
rearward boom-lift offset from swing axis; it is not separately dimensioned.
The owner subsequently confirmed COR height 2324.7 mm at Z-slide 151.75 cm,
boom 25°, level base and level trunnion. Close the geometry using 144.98 cm
joint height and the 118.38 cm link span: the link angle at boom 25° is
29.60398666793°, which rounds to the drawing's 29.6°. This supersedes the prior
exact use of that rounded angle (which gave COR 2324.62838166 mm). Boom pivot
height, link length, joint/pitch/COR offsets and swing/yaw axis spacing are retained.

Reference plumb height closure: 144.98 + 84.04 + 3.45 = 232.47 cm.
On the level reference frame, COR height in cm is `232.47 + Z_slide - 151.75`.
The known Z range 2–167.5 cm therefore gives COR 82.72–248.22 cm; X-slide and
yaw do not change that height at this level pose. With pitch/roll, derive world
position from the full transform, rather than using that level-only scalar rule.

At mast slide 195 cm and lower crowd 160 cm, holder/cap WP coincides with COR.
For other positions the WP displacement is `(mast_slide - 195) + (lower_crowd -
160)` cm along the rotated mast axis through COR. Mast/crowd travel does not
move COR. Reference coincidence and axial displacement are verified at the
known slide limits and pitch/roll limits; upper crowd remains relative to lower.

At X=30 cm, yaw-to-pitch is 59 cm rearward. At X=0 it is 29 cm;
84.04 cm vertical offset stays on the supported frame. At Z=151.75 cm,
pitch-to-COR vertical offset is +3.45 cm; other positions add the slide travel
difference along local up. Pitch-to-drill offset is 93.32 cm, replacing 93.472.

Cylinder pin mounts, equipment enclosure and exact antenna offsets remain
schematic. The crowd datums and effective rail envelope now use the source
calculations described below, replacing the former arbitrary mast/crowd offsets.
Gold spheres mark only the 11 requested actuator axes and slide reference points;
cylinder and pendulum markers are omitted. Rotational points use their axis
centers; slides use representative carriage/reference positions. X-slide uses
the modeled carriage center to distinguish it from the coincident pitch axis.
The sphere radius is for visibility, not a measured pin diameter. Track length
remains an estimate. **Show pivots & slides** controls both points and gold guide
highlights. With it off, the moved axis's annotations appear for two seconds;
the underlying steel guides remain visible. Shared crowd rails respond to either
crowd. Slide dimensions now measure zero-to-carriage travel, not assembly height.

Pivot measurements always use 3D world centers: horizontal = sqrt(delta North²
+ delta East²), vertical = delta up, angle = atan2(vertical,horizontal), signed
from selected A to B. These values do not depend on camera projection.

## Crowd and mast datums — working v0.4, November 3

Reviewed all retained machine-image sets, the dimensioned drawing record,
GEO-06/GEOMETRY and the selected 530v2 readable application. Source prefix:
`Production_dev/TD3-Auto/exports_ojjo_TD3_cr711S_530v2/StandardPLC.dev/Plc Logic/Application/`.
The relevant members are `DUTs/sPersistent_1.dut`, `Global Variables/Dimensions.gvl`,
`POUs/MACHINE_LEVEL/machineInit.pou`, `POUs/Utility/updateCalculatedDimensions.pou`,
`POUs/ACTUATORS/axesInit.pou`, `POUs/ACTUATORS/UPPER_CROWD.pou/UPPER_CROWD.pou`
and `POUs/MACHINE_LEVEL/checkEstop.pou`. Profile is family 3, version 2; persistent
values are declaration defaults, not a readback from a machine.

The lower-crowd datum is its bottom bearing-block edge above the mast-foot/
centralizer reference. UPPER_CROWD implementation explicitly defines positive-up
position as the gap from the top of the lower crowd's upper block to the bottom
of the upper crowd's lower block. This specific definition takes precedence over
the ambiguous StatePositions comment. Zero therefore means touching edges.
The viewer permits zero for this owner-requested preview; axesInit minimum is 1 cm.

`updateCalculatedDimensions` uses three 18.7-inch sleds, a 5.125-inch gap between
upper crowd and drifter, and an effective upper stop of 278 + 11 inches above
the lower-position datum. The schematic now includes all three sleds. The two
crowd sleds are each 47.498 cm long, with center separation `47.498 + upper` cm.
The old 160 cm extra separation and -65 cm lower-crowd placement are superseded.

For a level reference mast, source formulas in cm are:

```text
centralizer bottom height = -14 + Z - (197.5 - mast)
lower bearing bottom = centralizer bottom + 16 + lower
chuck bottom = centralizer bottom + 16 + lower - 63.2
drill tip = chuck bottom - (206.8 - upper)
drifter-to-top = (278 + 11 - (3*18.7 + 5.125))*2.54 - lower - upper
              = 578.5485 - lower - upper
```

At Z=151.75, mast=195, lower=160, upper=0, with level base/trunnion and
pitch/roll zero, heights above the shared ground plane are centralizer bottom
135.25 cm, chuck bottom 248.05 cm, nominal 200 cm screw tip 48.05 cm and drill
tip 41.25 cm. The screw is the first nominal length in sPersistent_1, not a
simulated loaded-product selection. At upper=206.8 cm the drill tip is flush with
the chuck bottom, as specified by that declaration.

The drawing COR stays 232.47 cm. The nominal chuck + CHUCK_TO_TARGET (-15.5 cm)
predicts WP 232.55 cm, an unresolved 0.08 cm difference. The owner's exact WP/COR
coincidence at 195/160 is retained by the schematic holder mounting. The older
source rotator-height nominal `87 + Z` differs from the drawing by 6.28 cm;
it is not used to move the drawing COR. Tilted poses use full transforms, with
these distances along the mast axis rather than world-plumb distances.

Relative to COR at mast=195, the centralizer bottom is -97.22 cm; its top is
-81.22 cm. The effective rail envelope starts 11 inches above that top and ends
278 inches farther along the mast. This reproduces the active top-clearance
formula, giving modeled foot-to-upper-stop extent 750.06 cm. It is a source-based
envelope, not a measured overall mast length: the same POU contains older 253-inch
and approximate rail-end comments that do not match the active arithmetic.
Photographs and CAD views support appearance but do not resolve those datums.
Physical rail endpoints remain an open dimensional check.

At the selected lower-crowd minimum 37 cm, the bottom bearing edge is 9.06 cm
above the modeled guide bottom. It stays there relative to the guide as Z, mast,
pitch and roll move. Version-0 minimum 44 cm gives 16.06 cm. The mast does not
need an arbitrary downward shift to retain the crowd on its guide.

The viewer now applies the non-operator manual upper-crowd geometric limit:
`upper_max = 573.5485 - lower` cm, leaving DRIFTER_TO_TOP_MIN=5 cm. It also caps a
lower-crowd edit at `min(270, 573.5485 - upper)` cm, holding the other coordinate
fixed. At lower=160, upper may reach 413.5485 cm; axesInit's initial 300 cm upper
limit is superseded in this source branch. The source operator/product upper
limits, automatic 10 cm top E-stop and stopping dynamics are separate behavior
and are not executed by this pose viewer. Alignment/profile presets trim upper
position if necessary to keep the requested holder pose within the rail envelope.

At lower=270 and upper=0, the active source still gives 308.5485 cm top clearance.
At lower=270 and upper=300 it gives 8.5485 cm. Thus the owner's expectation that
the fully stacked pair reaches near the top is not established by the inspected
source. No extra lower-crowd travel or shortened mast is inferred from that
expectation; the physical extent/limit needs confirmation if the corrected model
still disagrees with the rig.

Very low independent poses can still cross the ground: at Z=2 and mast=0 the
source centralizer formula gives -209.5 cm. This viewer does not run machine-state
ground-clearance interlocks or soil contact. The rail stops prevent leaving the
mast; they do not establish a permissible machine pose against the ground.
