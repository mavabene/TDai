# Run Update permissions and Auto-review setup

Established October 29, 2026 from the owner's standing authorization for Run Update.
This is the maintained permission catalog. It describes authorized work, not an
executable allowlist or a guarantee that every action will pass review.

## Enable the built-in reviewer

In the desktop app, use the permissions control below the message composer and
select **Approve for me**. Confirm it is selected in each chat used for updates.
If unavailable, organization/account settings may restrict the mode.

For local configuration defaults, these top-level settings select automatic review:

```toml
# Surface boundary-crossing requests for review rather than disabling approvals.
approval_policy = "on-request"
# Route eligible requests to the built-in reviewer instead of a manual prompt.
approvals_reviewer = "auto_review"
```

Keep the existing sandbox/filesystem restrictions. Do not set Full Access or
`approval_policy = "never"` as a substitute. Managed requirements can override
local defaults. Reopen the chat/app as needed to load changed defaults and confirm
the current chat's permission selection; saved settings alone do not prove the
effective mode. [Official Auto-review setup](https://learn.chatgpt.com/docs/sandboxing/auto-review).

Use the default reviewer policy. Do not replace `[auto_review].policy` with this
project catalog: that field replaces rather than extends the active policy.
The reviewer receives the approval request and compact conversation evidence;
it is not guaranteed to read arbitrary project files automatically. Before an
escalation, identify the applicable permission ID, exact target, intended effects,
and safeguards in the request. A denied action must not be retried indirectly to
evade review. Explain the denial and pursue only a materially safer alternative.

## Annotated permission catalog

The permissions below apply when the owner invokes **Run Update**. They do not
authorize unrelated work, installation, machine operation, or automatic updates
from the reminder task. Existing access to a file is not permission to publish it
to a new destination.

| ID | Permission and exact scope | Purpose / comment | Potential concerns and limits |
| --- | --- | --- | --- |
| U-01 | Read the development root `C:/Users/jcheney/Documents/TD3/Ojjo_TD3-1` and select saved mainline PLC/HMI `.project` files | Find current numbered versions without manual copying | Exclude letter-suffixed alternates and named test/recovered variants. Compare numeric revisions; ask about anomalies or conflicting same-version files. Never write back to development files. Unsaved IDE changes are not captured. |
| U-02 | Copy selected projects into `C:/Users/jcheney/Documents/Codex/TD3/Production_dev/TD3-Auto` and `TD3-HMI` | Refresh workspace inputs | Same-version copies can replace older content. Verify stable source and destination hashes. Libraries remain unchanged unless the owner identifies an update. Preserve unrelated files. |
| U-03 | Launch the installed CODESYS SP21 Patch 1 executable with `tools/run_codesys_exports.py` in a separate no-UI process | Generate readable exports from scratch copies | A scripting runtime can execute code with user privileges. Inspect the runner/exporter after changes. Use temporary copies and NoUpdates; do not save original projects, connect online, download, or force outputs. Missing libraries are reported, not automatically installed. |
| U-04 | Create scratch files under workspace `.export-work` and promote validated generated exports into the corresponding workspace export directories | Produce current source text and compare version notes | The supplied exporter clears its output directory. Run it only on fresh scratch copies. Preserve prior output on failure and distinguish source changes from environment-induced metadata differences. Cleanup may target only verified generated scratch/output paths, never whole source trees. |
| U-05 | Edit project documentation, TODOs, fingerprints, allowlist, and ignored local update receipts | Keep records consistent with the checkpoint | Review apparent errors in owner edits; distinguish reports, proposals, static observations, and actual tests. Do not mark machine validation complete based on export success. Receipts must not contain credentials. |
| U-06 | Write this workspace's `.git` metadata to stage selected files and create a normal commit on the agreed current branch | Save the reviewed checkpoint | Do not sweep in another chat's unfinished work, switch a shared checkout underneath a writer, run unrelated hooks without review, or use reset/force/amend operations to discard history. A different milestone branch requires its own agreed scope. |
| U-07 | Git fetch, normal push, and SHA verification for `https://github.com/mavabene/TDai.git` | Update and verify the owner's repository | This uploads source and records. Review selected paths and the actual origin URL before push; no new destination or force-push is authorized. Keep certificate verification enabled. Fetch does not authorize an automatic merge or rebase. |
| U-08 | Let Git use its existing credential-manager authentication for the authorized GitHub operation | Reuse the owner's sign-in | Authentication/account-policy prompts may still need the owner. Do not extract or print stored credentials, tokens, keys, or cookies. No credential-manager/configuration changes are implied. |
| U-09 | Write the configured Box subtree `C:/Users/jcheney/Box/Jam/Documents/ojjoDev/TD_Projects/Jam_TD3_box/prod_dev_ai` using `tools/Copy-ToBox.ps1` | Copy and hash-verify the workspace, Git metadata, and existing flat code aliases | This backup includes ignored/local files as well as tracked files and Box can upload them. Overwrite only matching versions; add new versions alongside old ones. Do not delete prior Box versions, purge/mirror deletions, or touch unrelated Box paths. Validate non-overlapping source/destination paths. The owner requires local-copy verification only; do not monitor or wait for cloud upload. |
| U-10 | Read local Git state, managed code candidates, and receipts during scheduled reminder checks | Remind at 4 PM, or at 9 AM about evidenced previous-day pending work | Reminder runs cannot import, export, commit, push, copy to Box, or run the full update. Avoid duplicate/non-actionable notices. Do not claim unseen development edits or uncertain prior-day work as facts. |

The configured Box mappings and retention policy are owned by
[DEVELOPMENT](DEVELOPMENT.md). The operational sequence is owned by
[Daily Update](../Daily%20Update.md). This catalog does not duplicate those procedures.

## What remains outside these permissions

Machine/controller connections, downloads, online changes, output forcing,
calibration writes, engine/hydraulic operation, changing safety logic, destructive
Git operations, deleting old Box versions, publishing to another destination,
installing/upgrading software or libraries, and broad security-setting changes
need separate specific authorization. Unexpected or ambiguous targets still need
clarification. Ordinary permission requests should go to Auto-review once active;
the main agent should not ask the owner to reauthorize U-01 through U-09 each run.

## Verify setup

Local setup performed October 29, 2026: added only the two top-level settings
above to `C:/Users/jcheney/.codex/config.toml`. Existing settings were parsed and
verified unchanged. Original config backup:
`C:/Users/jcheney/.codex/config.toml.before-auto-review-20261029-113601-3b31e1.bak`.
No custom reviewer policy, command allowlist, or broader sandbox access was added.
This chat's execution settings subsequently confirmed `approvals_reviewer =
"auto_review"` on October 29, 2026. Other chats should still confirm their own
active permission mode; a local default does not override managed requirements.

1. Select Approve for me and confirm it for the current chat.
2. Invoke Run Update normally. Routine allowed actions may need no review at all.
3. When a boundary action arises, request it with its applicable permission ID and
   concrete paths. Check the actual review result rather than assuming activation.
4. Do not manufacture a dangerous action to test permissions. If manual prompts
   remain, inspect the effective mode, managed restrictions, and the request type.
   Computer-use app approvals are a separate case and may remain manual.

For other projects, reuse this catalog's structure but register their actual
source, workspace, remote, backup paths, and allowed side effects. TD3's approved
paths and repository do not automatically authorize another project's actions.
