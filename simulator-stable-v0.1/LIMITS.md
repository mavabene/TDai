# Model command ranges — 530v2 readable source

Reviewed November 2, 2026. Source path relative to repository:
`Production_dev/TD3-Auto/exports_ojjo_TD3_cr711S_530v2/StandardPLC.dev/Plc Logic/Application/POUs/ACTUATORS/axesInit.pou`.
These are `COMMAND_LIMIT_MIN/MAX` initialization values, not `FB_VALID_MIN/MAX`,
measured stops, deployed settings, or all state-dependent restrictions.

| Model control | axesInit position units / range | Viewer range |
| --- | --- | --- |
| Boom swing | degrees -27 to 27 | -27 to 27° |
| Boom lift | degrees -18 to 30 | -18 to 30° |
| Joint lift | degrees -12 to 30 | -12 to 30° |
| Yaw | degrees -29 to 29 | -29 to 29° |
| X-slide | cm 0 to 30 | 0 to 0.30 m |
| Pitch | degrees -6 to 80 | -6 to 80° |
| Z-slide | cm 2 to 167.5 | 0.02 to 1.675 m |
| Rotator | degrees -38 to 38 | -38 to 38° |
| Mast slide | cm 0 to 197.5 | 0 to 1.975 m |
| Lower crowd | cm LOWER_CROWD_MIN_END_POS to 270 | 0.44 or 0.37 to 2.70 m |
| Upper crowd | cm 1 to 300 | 0.01 to 3.00 m |
| Lower rotary | revolutions -100 to 100 | Continuous bidirectional speed control |
| Upper rotary | revs 0 to 0 | Continuous bidirectional speed control |

Lower-crowd minimum is assigned in sibling
`POUs/MACHINE_LEVEL/machineInit.pou`: MACHINE_VERSION 0 gives 44 cm, otherwise
37 cm. Owner selected family 3 version 2 (3.2). Viewer defaults to MACHINE_VERSION 2, using the 37 cm minimum; the selector also offers the version-0 reference.
No deployed configuration is inferred. Upper rotary zero position limits do not
prove a physical prohibition on rotary movement; this viewer retains a separate
continuous speed control rather than interpreting zero as a mechanical stop.

Displayed linear positions are now source-range coordinates. To preserve the
assembly drawing pose, Z-slide 0.02 m, mast slide 1.95 m, lower crowd 1.60 m and upper crowd 0.01 m
map to their former reference positions; these drawing offsets are estimates,
not encoder zero calibration. Upper crowd remains relative to lower crowd as
confirmed by the owner. Pitch display direction was reversed following owner visual feedback; roll mapping remains
provisional. Rotator source comment says top tilting left is positive; the model
uses that direction. Speeds, state-dependent limits, interlocks, and runtime NVM
calibration are not simulated. The source upper-crowd POU can adjust its command
maximum dynamically; no claim of reproducing that behavior is made.

Only simulator files were changed. PLC/HMI source and binaries are untouched.

Owner clarification: both rotaries rotate continuously in either direction. Their controls now set signed speed (demo ±60 rpm), with Stop rotaries and reset stopping motion. Rotation wraps visually at 360 degrees with no position stop. The speed range is for visualization; lower-rotary axesInit speed settings are +8/-7.5 rev/s and upper-rotary settings are zero placeholders. Those are not implemented as hydraulic speed response.

Visual revision 0.2: red photo/CAD-inspired envelope and 1.8288 m scale figure. Nominal arm reaches and source strokes are preserved. Pitch-to-drill offset 0.93472 m is included within the 1.35 m yaw reach; centralizer width/thickness 0.62/0.16 m are source dimensions. Other envelope and vertical offsets remain estimated; see simulator README for provenance.

November 3 owner update: upper rotary visualization speed is now +/-200 rpm;
lower rotary remains +/-60 rpm. These are demonstration controls, not hydraulic
speed validation. The new Track-default reset uses the documented nominal
non-GPS Track pose with model-plumb mast; see README for source paths and the
disabled upper-crowd Track-command caveat. The assembly-reference reset remains.
