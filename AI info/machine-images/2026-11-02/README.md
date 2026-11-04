# Owner-supplied TD3 CAD reference images

Received November 2, 2026 in the standalone 3D simulator discussion. The owner
requested that these images be retained as machine reference information.
Five unique PNGs are retained, with copied bytes verified against their source
SHA-256 hashes. Attachment 03 was byte-identical to attachment 02 and was removed
at the owner's request. Original attachment numbering is retained.

These are supplied visual context, not measured rig geometry or calibration.
CAD revision, machine configuration, pose, measurement endpoints, coordinate
origin, and CAD axis conventions have not been established. Interpret geometry
using [the maintained geometry record](../../../docs/GEOMETRY.md).

| Attachment | Saved image | Visual content |
| --- | --- | --- |
| 1 | [td3-angled-dimensioned.png](td3-angled-dimensioned.png) | Angled full-machine view with CAD distance/component callouts |
| 2 | [td3-angled-overview.png](td3-angled-overview.png) | Angled full-machine view showing mast, articulated support, tracks, and enclosure |
| 4 | [td3-end-view.png](td3-end-view.png) | End-on view along the chassis, with mast and tracks visible |
| 5 | [td3-side-view.png](td3-side-view.png) | Side view showing mast, support linkage/cylinders, chassis, and track |
| 6 | [td3-boom-linkage-track-detail.png](td3-boom-linkage-track-detail.png) | Close-up of chassis/support linkage and track with CAD callouts |

## Visible measurement annotations

Transcribed approximately in millimetres from the screenshots; rounded here to
avoid implying physical precision. These labels are CAD readouts, not adopted
simulator dimensions. In particular, CAD dX/dY/dZ must not be equated with the
recorded TD3 machine axes without identifying the CAD frame and selected points.

| Image | Visible labels and approximate values |
| --- | --- |
| 01 | Center Dist 2648.979 mm; cdX 725.000 mm; cdY 2324.705 mm; cdZ 1042.693 mm |
| 06 | Dist 1023.997 mm; dX 649.000 mm; dY 792.066 mm; dZ 0.008708 mm |

## Standalone simulator scope supplied in this discussion

The first requested deliverable is a laptop-only articulated 3D model using simple
blocks for the main assemblies/actuators and representative, correctly located
pivots. It is separate from the PLC for now. The images support identifying
assemblies and approximate proportions; exact missing pivots, dimensions, joint
limits, and zero poses remain to be established before claiming model accuracy.
No model implementation, PLC integration, or geometry validation is recorded here.

Longer-term requested capabilities include code-driven actuator motion and speeds,
a simulated world with driving, remote operation, and a physical base inclinometer.
Those describe future intent, not implemented interfaces or authorization to
connect a controller or operate hydraulic hardware.
