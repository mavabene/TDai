# Development and verification workflow

Status: proposed workflow, with one owner-selected handoff preference. The initial
phase is documentation and assessment. This record does not authorize downloads,
online changes, output forcing, calibration writes, engine operation, or motion.

## Confirmed code handoff

On October 27, 2026, the owner requested code to review, then copy and paste,
with clear explanations of exactly where to paste it. Use that workflow for
future PLC/HMI work unless a later user instruction changes it. The owner will
address different milestones in separate chats; share the maintained project
records between those chats rather than depending on one chat's memory.

For each proposed code change, provide:

1. **Identity and effect:** exact source baseline, affected project/application,
   trigger, expected behavior, main failure/recovery behavior, and assumptions.
2. **Paste location:** export/archive member, CODESYS tree path, POU and
   action/method, and a unique existing anchor identifying the replacement area.
   Use line numbers only as an aid; exports can shift.
3. **Separate blocks:** declarations/variables in one block and implementation
   in another. State whether each block replaces or adds content. Provide a
   contiguous complete replacement region rather than scattered line edits.
4. **Dependencies:** caller changes, types, library versions, settings/defaults,
   persistent layout, PLC/HMI network fields, and migration requirements, where
   affected. Explain application order if multiple objects must change together.
5. **Review and validation:** why the change addresses the cause, the relevant
   boundary/fault cases, tests actually run, and checks still required in CODESYS
   or on hardware. Label the proposal as unapplied until there is evidence of
   application.

The owner may batch several changes in CODESYS and edit proposed code. A fresh
export is not required after every change. Record owner-reported changes as
reported, keeping them distinct from the last inspected source; do not assume a
proposal was applied verbatim or that an older export includes later changes.

Continue from the available evidence where practical. Request updated source
when the task depends on the current implementation, and ask only for what is
needed: a pasted section or relevant POU may suffice instead of a complete export.
When the owner supplies a new export, reconcile it with reported changes and
proposals, preserving intentional owner edits and flagging unexplained differences.
Review owner edits for apparent defects as well. Identify the affected behavior,
explain the evidence and uncertainty, and recommend a correction when warranted.
Do not silently revert an edit or assume it is correct solely because the owner
made it.
Record compilation separately from source comparison and rig validation. A pasted
snippet can update knowledge of that section without establishing a complete new
project baseline.

## Starting a milestone chat

Read [README](../README.md), [SOURCE_BASELINE](SOURCE_BASELINE.md), and relevant
owning records. A concise starting brief should identify:

```text
Milestone and desired outcome:
Current behavior and a concrete example:
Required behavior and completion/failure criteria:
Selected source baseline and validation configuration:
Known constraints, open questions, and relevant finding IDs:
Authorized scope for this chat:
```

The likely first milestone is a new locating process. Start with Q-01 through
Q-05 in [OPEN_QUESTIONS](OPEN_QUESTIONS.md), then retrieve the specific geometry
and interface evidence needed. Do not infer a plumb-installation requirement or
an entire automatic sequence from a filename or version-history comment.

## Working through a change

Establish expected and observed behavior before debugging. Trace the input,
state transition, permissives, target calculation, final output, operator status,
and relevant timing. Review a representative normal path and a failure/recovery
path. Preserve the existing machine's configuration distinctions.

State the design before making a consequential change to machine behavior or a
major interface. Once scope is agreed, routine implementation, inspection, and
documentation within that scope do not need repeated approval. Under the
confirmed handoff, implementation proposals are code blocks for owner review;
the agent does not silently apply them to the exported source.

For data that outlives a scan or crosses tasks, identify ownership, lifetime,
capacity, synchronization, and stale/overflow behavior where relevant. For NVM
and configuration, distinguish defaults, current values, validation, migration,
and rollback. Apply these checks to affected code rather than launching a broad
refactor for every small change.

## Verification appropriate to the change

| Stage | Evidence to record | What it establishes |
| --- | --- | --- |
| Static review | Exact source, paths, trace, declaration/interface comparisons, arithmetic examples | Source properties and hypotheses; no runtime or hardware claim |
| Offline calculation or simulation | Model, inputs, expected results, frame/units, boundary/fault cases, actual outputs | Behavior of that model/test setup |
| CODESYS compile | Project identity, IDE/compiler/target/library set, build result and diagnostics | Build result for that configuration |
| Bench integration | Hardware/firmware, interface/configuration identity, stimuli, captures, actual outputs | Observed integration behavior within the recorded setup |
| Machine validation | Rig/product/calibration, procedure, operator, measurements, operating envelope, result and limits | Observed machine behavior for those conditions |
| Release | Accepted scope/evidence, paired versions and configuration, backup/recovery and deployment record | The selected release and where it was installed |

No local CODESYS compile/test harness was identified in the initial assessment.
Existing `Production*/tools` scripts were not adopted or run. Exact toolchain and
available bench/machine procedures remain open. Documentation-only work needs
link/reference and factual checks, not a claimed PLC compile.

For targeting changes, expected cases include the aligned zero pose; positive
and negative X/Y/Z/heading offsets; coupled boom/yaw moves; the permitted pitch/
roll envelope; reach boundaries; product/reference changes; invalid/stale data;
and mode/stop/restart transitions. Derive expected results independently of the
code under review. Choose actual cases and acceptance values from the feature's
requirements; this list supplies categories, not machine operating instructions.

A numerical helper repair should verify both signs, values at and around its
valid limits, and the caller's invalid-target handling. A communications change
should verify both endpoints, resolved shared types, units/signs, timing,
freshness, and loss/reconnect behavior. Do not add broad redundant tests when the
relevant checks already pass and no unresolved issue justifies more testing.

## Durable result record

Use this format when there is meaningful new verification evidence, in
`docs/verification/<date>-<change>.md`. Keep purely proposed tests labeled planned.

```text
Change / requirement / finding IDs:
Status: planned | reviewed | compiled | tested (specify stage) | accepted
Date and responsible person:
Source/archive/project identity and hashes:
Toolchain, libraries, firmware, rig/product/configuration/calibration:
Setup and permitted scope:
Procedure, inputs, and expected results:
Actual results and evidence links:
Failures, uncertainty, untested conditions, and remaining limits:
Acceptance/decision and next action:
```

Keep the initial assessment as a dated snapshot. A later fix should link back to
its finding and forward to its result record; it should not erase the original
observation or claim that a proposed test has passed.

## Repository and document maintenance

On October 28, 2026, this workspace was initialized as a Git repository on `main`,
with `origin` set to `https://github.com/mavabene/TDai.git`. The remote advertised
no branches or commits when inspected. Initialization itself staged, committed,
and pushed no files. The selected initial code inventory is recorded below.
Repository-local `http.sslBackend=schannel` uses Windows certificate validation
because Git's OpenSSL certificate-chain check failed on this connection.
Certificate verification remains enabled.

The owner selected this workspace as the source for Git and selected all existing
library binaries for the initial baseline. Track the 530v1 PLC/HMI `.project`
files and export archives under `Production_dev`, all `.library` files under
`Library` and `Production_dev/libraries`, and maintained records. See
[CURRENT_CODE](CURRENT_CODE.md) for the fingerprinted inventory and its limits.
The initial selection includes 19 library binaries, including GPS and older
versions; inclusion does not mean every library is used by the current projects.
Historical application versions under `Production` and generated IDE/cache files
are excluded from Git. They have not been deleted from the local workspace.

For later updates, copy the latest changed files here, identify the components
they replace, review the differences, and update the Git allowlist/inventory when
names change. Commit the replacement and removal of its prior managed version
together so history is retained. Do not remove unrelated variants or uncommitted
files merely because their version numbers are lower. No daily schedule or
background synchronization is enabled; updates run when requested.

### Owner-supplied snapshots and Box backup

The owner develops in a separate local folder outside the agent's working access.
When ready to update Git, the owner will copy the relevant updated files into
this workspace. Review and version those copies; do not access or synchronize
back to the owner's development folder. Code elsewhere is not automatically
included, and copying a binary project alone does not update its readable export.
Exports can be supplied in batches as already agreed.

The Box destination supplied by the owner is:
`C:/Users/jcheney/Box/Jam/Documents/ojjoDev/TD_Projects/Jam_TD3_box/prod_dev_ai`.
The owner selected a latest-only copy: update changed components and remove their
superseded versions rather than accumulating dated copies. Git preserves committed
history. Git ignore rules govern Git tracking; they do not silently narrow the
requested backup. GitHub updates and the Box backup are separate results to report.

**Current hold:** the owner explicitly selected this workspace as the source and
instructed leaving differing Box code untouched for now. Do not import Box code
or overwrite/delete its differing files. No Box copy has been performed.

The October 28 comparison found matching HMI, motor3_3105, td3_31012, and
td3_3101011_SP21 files, but different PLC project contents:

| Location | PLC `ojjo_TD3_cr711S_530v1.project` SHA-256 |
| --- | --- |
| Workspace `Production_dev/TD3-Auto/` | `fd5fc26baf2eb8694bb4a43ca07fa4628548cb3b5e1e1d4f9e7096a3bde8e1c3` |
| Box `TD3-Auto/` | `928982e99e1ce60eb3d50490e9cadc3dc82b7df2760bd779f468534118db9a87` |

The directory layouts also differ: workspace code is under `Production_dev`,
while Box currently has root `TD3-Auto`, `TD3-HMI`, and `Libraries` directories.
Before enabling updates, establish an explicit path mapping and resolve protected
differences. Finish Git operations and coordinate writers before capturing files;
verify copied files by hashes. Delete only identified superseded managed files
after replacement succeeds and their history is preserved. Never purge the entire
Box tree or remove unrelated files. Verify resolved source/destination paths and
every deletion target before mutation; paths must not recurse into one another.

A verified local copy establishes that the Box-synced folder received the files.
Report cloud upload completion only when Box sync status provides that evidence.
Writing outside this workspace may require a destination-specific filesystem
permission when the actual path is known. No backup, scheduled synchronization,
or GitHub upload has been performed under this workflow yet.

Before handoff, verify internal links and source keys, check source identities,
and reconcile affected summaries with actual results. Update README's current
position at milestones. Add documents only when an existing owning record cannot
serve, and add their ownership to README. Keep attachments and example guidelines
as provenance, not a second changing set of requirements.
