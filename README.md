# TD3 diesel hydraulic drill rig development

Documentation and source-assessment workspace for the TD3 machine, with an ifm
CR711S PLC and CR1203 HMI. Initial assessment: October 27, 2026, California time.

## Current position

The supplied `530v1` PLC/HMI archives are the **review baseline**. Their copies in
this workspace match the user-named originals by SHA-256. This identifies the
reviewed files; it does not establish what is deployed on any rig.

This first pass establishes documentation, a source map, geometry context, and a
prioritized assessment. Machine code and CODESYS project binaries were left
unchanged. No CODESYS compile, simulator, controller connection, or machine test
was performed. The workspace was not a Git repository when assessed.

On October 28, the workspace was connected to the owner's GitHub repository.
See [repository setup](docs/DEVELOPMENT.md#repository-and-document-maintenance)
for the remote and tracking policy.
The initial code/documentation baseline has been committed and pushed to `main`.
The selected code-tracking scope and fingerprints are in
[current code inventory](docs/CURRENT_CODE.md). Box updates are on hold to preserve
the differing PLC project already in that folder.

The owner plans separate chats for different milestones. The first will likely
be a new locating process. The recommended next step in that milestone chat is
to define its behavior and validation rig, then close the requirements and
geometry gaps that affect it. The name “ET Plumb” and version-history comments do
not yet define that feature.

For future PLC/HMI changes, the owner wants reviewable code to copy and paste into
CODESYS, with clear instructions identifying exactly where to paste each block.

## Start here

| Record | Owns |
| --- | --- |
| [TODO list](TODO.md) | Pending/deferred work and its dedicated chat names |
| [Agent guidance](AGENTS.md) | Reviewed working rules, active for this workspace |
| [Source baseline](docs/SOURCE_BASELINE.md) | Exact inputs, hashes, version identity, and archive-member reference keys |
| [Architecture and source map](docs/ARCHITECTURE.md) | Observed PLC/HMI execution, task configuration, interfaces, and navigation |
| [Machine geometry](docs/GEOMETRY.md) | Maintained interpretation of the supplied physical context, frames, signs, and reference points |
| [Initial assessment](docs/ASSESSMENT-2026-10-27.md) | Dated review findings, evidence, coverage, and limitations |
| [Open questions](docs/OPEN_QUESTIONS.md) | Missing information and decisions, ordered by the work they block |
| [Proposed development workflow](docs/DEVELOPMENT.md) | Change handoff, verification, source refresh, and result-record format |

Read this current position first, then only the records relevant to the task.
Detailed evidence belongs in its owning record, not in repeated chat summaries.

## Existing material

```text
TD3/
  README.md
  TODO.md
  AGENTS.md
  docs/                    maintained project documentation
  AI info/
    ET_Plumb_Machine_Context.txt
    reference-guidelines/  unchanged coworker examples, reference material only
  Production_dev/
    TD3-Auto/              530v1 PLC project and supplied export archive
    TD3-HMI/               530v1 HMI project and supplied export archive
    libraries/             candidate development library binaries
    tools/                 existing scripts; not yet assessed as a workflow
  Production/              other releases and historical material
  Library/                 additional library binaries and IDE files
```

Do not select a baseline by newest filename, neighboring loose GVL file, or folder
name. `Production` and `Production_dev` are existing labels, not acceptance records.
See the [baseline](docs/SOURCE_BASELINE.md) before comparing versions.

## Documentation structure as work grows

Keep the records above small and distinct. Add the following only
when there is real content to maintain:

| Future location | Create when |
| --- | --- |
| `docs/requirements/<feature>.md` | A feature needs an agreed behavior and acceptance specification |
| `docs/interfaces/<interface>.md` | A CAN, network-variable, I/O, or data-format contract has been traced |
| `docs/hardware/<configuration>.md` | Drawings, calibration, and configuration identity are available |
| `docs/decisions/<date>-<topic>.md` | A consequential decision needs rationale beyond its owning guide |
| `docs/verification/<date>-<change>.md` | Compile, bench, or machine evidence needs a durable result record |

Do not create empty specifications or a permanent report for every chat. Preserve
dated assessments as snapshots; update current facts in their maintained home.
References to future folders above are a proposal, not a claim that they exist.
