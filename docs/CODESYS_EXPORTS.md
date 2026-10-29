# Readable CODESYS exports

The owner-supplied exporter uses CODESYS `projects` and `system` scripting APIs.
It must run in CODESYS's scripting runtime, not normal Python. CODESYS can launch
scripts from the command line with `--runscript` and `--noUI`.
[Official command-line reference](https://content.helpme-codesys.com/en/CODESYS%20Development%20System/_cds_commandline.html).

## Verified local route

Installed executable:
`C:/Program Files (x86)/CODESYS 3.5.21.10/CODESYS/Common/CODESYS.exe`.
Profile: `CODESYS V3.5 SP21 Patch 1`.

On October 29, 2026, a separate instance exported temporary copies of both saved
workspace projects using the supplied script. It exited with code 0 and emitted
success markers for PLC and HMI. The original workspace projects had identical
SHA-256 values before and after the run. No compile or controller connection was
performed; no original project was saved by this export operation.

| Input | SHA-256 | Generated files |
| --- | --- | ---: |
| `Production_dev/TD3-Auto/ojjo_TD3_cr711S_530v1.project` | `b0d7c3a5b3a2170920f8082a7b48a0b815471c031130a2a046ce0434c4a141b9` | 418 |
| `Production_dev/TD3-HMI/ojjo_TD3_cr1203_530v1.project` | `c9d1f33aeab18df38737a0849a89cddbd26d083fe1a3dd394f319fea742a8488` | 189 |

Existing loose export directories were already present in each project folder.
The generated HMI tree matched the existing HMI tree byte-for-byte. The PLC tree
matched except for three Library Manager metadata files. All other PLC files,
including ST code and Version, matched. Preserve the owner's existing exports;
do not overwrite their Library Manager metadata with this instance's unresolved
library configuration. The fresh PLC text confirms the corrected ASIN clamp and
the Version entry describing that fix.

**Limit:** CODESYS reported unresolved framework/system/visualization libraries.
Text extraction succeeded; dependency resolution and compilation were not proved.
Do not install libraries, upgrade projects, or treat this as a build result just
to suppress these diagnostics. This custom exporter is not a complete native
project export and does not preserve every visualization or other non-text object.
Keep `.project` and `.library` binaries as the full source artifacts.

## Daily Update procedure

1. Export when a saved workspace project changed or its readable output is absent
   or stale. Saved copies are authoritative; unsaved edits in an open IDE session
   are not included. Do not drive the owner's existing editing sessions.
2. Launch a separate CODESYS process using the executable/profile above and:
   `--runscript="C:/Users/jcheney/Documents/Codex/TD3/tools/run_codesys_exports.py" --noUI`.
   Use a hidden process window and capture stdout/stderr. This launch may need
   normal app execution approval. The reusable runner implements the same
   temporary-copy approach; its complete orchestration should be checked on its
   first invocation (the initial successful run used a simpler temporary wrapper).
3. The runner copies only the two configured projects into a new `.export-work`
   directory, opens them with `VersionUpdateFlags.NoUpdates`, calls the exporter,
   and verifies original input hashes and required Version files. It writes
   `result.json` only after both outputs pass those checks. Update its explicit
   input paths when the owner selects new project filenames.
4. Check exit status, completion marker, result manifest, diagnostics, main POUs,
   Version notes, and source hashes. Review unknown object types recorded in
   `s.txt`; file counts alone are not proof of complete coverage. If an input
   changed during export, retry from the new saved copy rather than pairing stale
   output with that binary.
5. Compare against existing loose export trees. Promote complete validated output
   into the corresponding `exports_<project-name>` directory only after reviewing
   differences. Preserve original ZIP review snapshots. Do not replace resolved
   library metadata with environment-induced differences without a reason. Keep
   old outputs intact on failure and label them stale. Validate absolute paths
   before any replacement/deletion; remove only superseded generated export files.
6. Include approved readable outputs in the Git checkpoint, update code identity
   records, and use the new Version entries to inform the commit message. Report
   extraction separately from compile/library validation. Box copying follows the current authorized policy in DEVELOPMENT.

`tools/codesys_export.py` is an unchanged copy of the supplied
`C:/Users/jcheney/Documents/GetDiff/simpleDiff/comp_new/Library/export.py`.
The script clears its output directory before export, which is why it is run only
on fresh temporary copies. Its commented Git commands are inactive. Its
`isfolder=true` typo is caught by a broad exception and may affect empty-folder
handling; it is not a verified full-fidelity export format. Improving that helper
or adding a native CODESYS export can be separate tooling work if needed.
