# SP21 migration checkpoint — October 29, 2026

Status: imported and statically reviewed; not compiled or machine tested.
Owner-requested Run Update imported the latest unambiguous saved mainline projects
from the authorized development root. PLC 530v1 and historical ZIPs remain intact.

| Project | SHA-256 |
| --- | --- |
| PLC `Production_dev/TD3-Auto/ojjo_TD3_cr711S_530v2.project` | `f0f2715c4105ec95c34922b8799e46e05efda05daf9d0907d8dbe3c4d413a6db` |
| HMI `Production_dev/TD3-HMI/ojjo_TD3_cr1203_530v1.project` | `6839eff3c3650f51d5f58d50f966a7aa45598baa3b627026a3391c173f7dad50` |

CODESYS SP21 Patch 1 extracted scratch copies with NoUpdates, producing 418 PLC
and 189 HMI files and the runner's success manifest after input hash verification.
An initial AP Installer logging access error prompted a separate reviewed retry;
the first process subsequently completed successfully. Scratch results are local
execution evidence, not machine releases.

Compared with the prior 530v1 loose export, PLC Version adds `v2 SP21` and changes
its active string to `5.3.0v2`. Three generated Project Information POUs differ:
the project-name strings become 530v2 and GetBooleanProperty adds the
IsStorageFormatPinned property returning FALSE. All other non-library exported
files match. HMI non-library exported files match, including VersionHMI.
No new actuator/interlock/timing changes were observed in the exported control
text; this custom export does not capture all visualization or project settings.

PLC library metadata differs at project, StandardPLC, and SafetyPLC levels.
The new 530v2 export retains the metadata captured by this extraction environment;
it is not a verified dependency-resolution baseline. Existing 530v1 metadata is
preserved. The differing HMI project-level library metadata was not promoted;
all other HMI output matches the prior tree. Unknown object-type inventories in
s.txt match prior exports; these include settings, application containers,
image pools and other objects not fully represented by this exporter.

The owner reported opening PLC code in SP21 with many errors and supplied a
screenshot of unresolved visualization placeholders. The exact opened file and
installed visualization profile were not established by that screenshot. No
library installation, project upgrade, code repair, compile, online connection,
or hardware validation was performed by this checkpoint.

Next action: inspect the current visualization profile and first compiler errors,
then establish compatible visualization packages and ifm target dependencies.
Do not treat the SP21 version note as acceptance of a working conversion.

Seven pre-existing untracked Library binaries remain untouched and excluded from
Git pending identification by the owner; CURRENT_CODE lists them. Full-workspace
Box copying includes local files under the standing policy. Git/Box results and
elapsed time are recorded in the ignored local update receipt after verification.
