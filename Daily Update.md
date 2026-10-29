# Daily Update

Say **“Run Update”** in a TD3 project chat to run this workflow. This is an
owner-requested checkpoint of workspace files, not a machine release. Established
October 29, 2026.

## Scope

- Workspace: `C:/Users/jcheney/Documents/Codex/TD3`.
- GitHub: `https://github.com/mavabene/TDai.git`.
- Include maintained records and selected PLC/HMI projects, exports, and libraries
  under the [development policy](docs/DEVELOPMENT.md) and `.gitignore`.
- Import the latest saved mainline PLC/HMI projects from the authorized source
  folder using DEVELOPMENT's import policy. Unsaved IDE edits are not included.
  Libraries stay unchanged unless the owner identifies a library update.
- **Box updates are authorized** without asking the owner again. The owner lifted
  the hold on October 29, 2026, including replacement of the previously differing
  Box PLC copy. Workspace files are the source; use DEVELOPMENT's destination
  and version-retention rules. GitHub and Box have separate outcomes.

## Run the update

1. **Establish state.** Read `AGENTS.md`, this file, DEVELOPMENT, README, TODO,
   and the code inventory as needed. Inspect branch, status, staged changes,
   upstream, and recent commits. Coordinate active writers before committing
   shared work. Stay on the current agreed branch; do not switch another chat's
   checkout, merge features, or publish unfinished work just to finish a checkpoint.
2. **Review available changes.** Inspect changed records and copied code files.
   First preview `tools/import_latest_projects.py`, then run it with `--apply`
   when selection is unambiguous. It copies only the latest mainline PLC/HMI
   projects and verifies hashes. Do not delete old files during import. Ask about
   unfamiliar naming or conflicting same-version copies rather than guessing.
   Refresh readable PLC/HMI exports from changed saved workspace projects using
   [the CODESYS export procedure](docs/CODESYS_EXPORTS.md) before reviewing code
   and version notes. If exporting fails, preserve the last good exports and
   report them as stale; do not silently label them current.
   Check managed code folders for newly copied project/library/archive
   versions currently ignored by the allowlist. Preserve owner edits but flag
   apparent problems with evidence. Do not implement new machine-code changes,
   require an export after every edit, or assume binary/export names imply
   matching content. Resolve ambiguous replacements before discarding files.
   Check the available PLC `Version` GVL and HMI `VersionHMI` GVL for new or
   revised version-history notes, following the guidance below.
3. **Reconcile records.** Update affected README status, TODO entries, code
   fingerprints, and owning guides. Distinguish proposals, owner reports, inspected
   source, compilation, and machine tests. Do not mark tasks complete without
   evidence or erase dated assessment history. Preserve useful resume context.
4. **Prepare the checkpoint.** Update the allowlist for identified new versions.
   Remove only superseded managed versions whose replacement the owner identified;
   preserve unrelated library variants and local historical material. Review
   additions/deletions, relevant source/interface differences, links, fingerprints,
   and maintained-document whitespace. Preserve supplied reference bytes. Run
   appropriate available checks and report their limits; do not claim unavailable
   CODESYS/hardware checks or start an unrelated test campaign.
5. **Commit and push.** Fetch/check remote state. Stage only intended checkpoint
   files, preserving another writer's unfinished or staged work. Commit with a
   descriptive message when content changed; push the agreed current branch.
   Never force-push, silently reset, or auto-merge a release. Resolve divergence
   within authorized scope or explain the concrete blocker while preserving work.
   Verify the remote branch SHA matches the intended local commit. A clean tree
   with unpushed commits still needs a push. An unchanged, already-pushed tree
   needs no timestamp-only commit.
6. **Update Box.** Copy the latest workspace files to the configured Box folder
   without another user confirmation. Use explicit path mapping, validate absolute
   paths, replace matching versions and hash-verify copied files. Add new versions
   alongside prior versions; do not delete old Box versions or mirror deletions.
   Preserve unrelated files. If version identity is unclear, preserve both and
   report the ambiguity. Update matching unversioned documents normally.
   The former PLC difference is no longer
   a hold. Do not copy Box files back into the workspace. Report local-copy and
   cloud-sync results separately; never claim cloud completion without evidence.
7. **Record and report.** After verifying the push, write the local receipt below.
   Report branch/commit, main changes, checks and limits, remaining work, and Box
   outcome. Report failures as failures. If interrupted, inspect actual Git and
   remote state before resuming.

“Run Update” authorizes this review, record maintenance, Git commit/push,
and the Box copy under the authorized version-retention policy. Normal filesystem/
network permissions may still require an app approval. It does not authorize
controller operations, new code fixes, remote-history rewrites, or release acceptance.

## Version-history notes and Git messages

The owner uses the PLC **Global Variable List `Version`** to describe broad
version changes. Consult it during every Daily Update when readable source is
available. Also check the HMI `VersionHMI` list and supplied library change notes
when relevant. [SOURCE_BASELINE](docs/SOURCE_BASELINE.md) identifies the original
PLC/HMI archive members as P-VERSION and H-VERSION; use the current owner-selected
exports or pasted lists when newer source is supplied.

Compare these notes with their previous committed contents, including edits to
an existing version entry rather than only newly numbered releases. Use relevant
new descriptions to explain the purpose of the actual checkpoint in the Git
commit title/body. Distinguish PLC, HMI, and library scope when needed. Do not
repeat old release notes as new changes or copy the complete history into each
commit message.

Cross-check the notes against the available file/code differences and owner
reports. Treat TODOs, questions, “begin,” and testing plans as provisional, not
completed or verified behavior. Flag apparent discrepancies; do not silently
rewrite the owner's notes or assume they prove a compile or machine test. A
documentation-only checkpoint must not claim older machine changes as its work.

If only a binary project/library changed and its readable version notes have not
been supplied, say that the notes could not be checked. Continue with a factual
message based on available evidence; request the relevant GVL only when needed
to resolve an important ambiguity. Do not require a complete new export or edit
the version GVL automatically. The active version string and the version-history
comments are separate evidence, and either may be unchanged during development.

## Local receipt

Use `C:/Users/jcheney/Documents/Codex/TD3/.daily-update-state.json`, excluded from
Git, to record the most recent verified invocation without making the repository
dirty after every run. Create it on the first invocation. Missing state means no
invocation is recorded, not that an update failed. This is local execution state,
not another TODO list.

Record `last_successful_run_utc`, `timezone` (`America/Los_Angeles`), `branch`,
`pushed_commit`, `remote`, `remaining_changes`, and `box_status`. Keep prior success
if a later attempt fails; record a separate `last_attempt` with time/failure details.
Success means the intended Git checkpoint was verified remotely. A Box-copy failure does not erase Git success; record it separately and report
the overall update as partial until the required copy succeeds.
Note any work deliberately excluded. Never store credentials in the receipt.

## Reminders

Schedule: **every day at 4 PM and 9 AM, America/Los_Angeles**. Morning defaults
to 9 AM and can be changed by the owner. Scheduled runs inspect and remind only;
they do not run this update, stage/commit/push, change branches, or write to Box.
The app reminder is named **TD3 Daily Update reminders**, automation ID
`td3-daily-update-reminders`, attached to the project setup chat.

Inspect local Git status, unpushed commits against the known upstream, new code
candidates in the managed folders, and the receipt if present. Ignore generated
caches and the receipt itself. Missing receipt alone does not trigger a reminder.
An already-pushed, clean workspace without new candidate files stays quiet even
when no explicit Daily Update invocation is recorded.

- **4 PM:** remind if meaningful changes or unpushed commits remain since the
  last checkpoint. New changes after an earlier run can need another update.
- **9 AM:** remind only if evidence shows unfinished changes from an earlier
  local calendar day. Use pending-file modification times, unpushed-commit dates,
  and recorded failures/remaining work. Today's first edits alone do not qualify.
  If age is uncertain, do not assert a missed prior-day update as fact.

Keep reminders short: identify pending work and suggest **“Run Update.”**
Stay quiet when nothing actionable has changed. Use available automation history
to suppress duplicates for the same pending state and scheduled slot/date. Notify
only on due pending work, meaningful changes, failures, or required owner action.
If inspection fails, explain that failure without claiming an update was missed.
This monitor cannot see files still in the separate development folder.
