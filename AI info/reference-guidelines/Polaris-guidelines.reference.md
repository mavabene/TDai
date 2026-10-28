# Polaris-specific guidance

Applies throughout `nx-polaris`, including nested repositories.

<!-- doc-status: active -->

## Document ownership and handoff

One fact has one maintained home; other records link to it. Start with the short
[current position](codex-docs/POLARIS-PROGRESS-LOG.md#current-position), then read
only the owning records needed for the task. Do not routinely reload the complete
historical log or reconstruct current state from dated learning notes.

| Information | Maintained home |
| --- | --- |
| Working preferences, authorization and agent rules | This `AGENTS.md`; nested instructions link to applicable workflow details |
| Agreed product behavior, proposed design and architecture questions | [Tablet architecture](codex-docs/POLARIS-TABLET-ARCHITECTURE.md) |
| Current project position, next actions and brief milestone history | [Progress log](codex-docs/POLARIS-PROGRESS-LOG.md) |
| Component operation, interfaces and validation commands | Its existing guide beside the application/tool source |
| Owner understanding and next learning gaps | [VibeWise progress](.vibe-wise/progress.md#current-learning-checkpoint); profile holds background and links |
| What was tested, on which source/configuration, and its limits | The linked result record/PR, not repeated test counts in every summary |

Design records describe intended behavior, code describes implementation, and
evidence describes observations. Flag a disagreement and resolve it at the owning
source; do not silently change an approved requirement to match code or infer
acceptance from a test pass. Record accepted decisions promptly in their owning
document. Summarize meaningful milestones once; routine discussion replies,
helpers and attempted fixes do not each need a project-log entry.

Follow the [documentation handoff check](tools/docs-check/README.md) before handing
back a feature, fix or documentation change. Compare affected summaries with the
actual source/results as well as running the checker. Fix errors and record a
disposition for review warnings. Update affected open work, or state that project
status is unchanged. New Markdown needs a reason why an existing owning guide
cannot serve. Do not create permanent checker logs or another per-session report.

`nx-polaris` is now the private workspace-records Git root; the Android demo and
Linux lab keep their separate build/Git roots. See [repository boundaries](README.md).
Preserve the explicit records allowlist. Use a scoped branch and PR for records
changes, stage only owned files, push for backup, and leave merging to owner
authorization. Coordinate shared records and Git operations in the room; do not
switch the shared checkout underneath another writer or stage their unfinished
edits. Never force-push. Application changes follow their own repository workflow.
The future product should keep code-specific guides with its reviewed source;
move canonical ownership once rather than maintaining another copy here.
At product-repository setup, register its active documents/check command and adopt
the same handoff/PR requirements before starting the first product feature.

Tutorial learning consolidation remains deferred until the owner finishes the
tutorial. Preserve its history and evidence; this process does not approve a
bulk archive, deletion or promotion of lab assumptions into product requirements.

## Live coordination between agents

- When working on Polaris, join the shared PC chat room and read its current
  agents, messages and tablet reservation before SSH or changes to shared files.
  Use the canonical helper even from another checkout:
  `C:/Users/jfrabosilio/Documents/nx-polaris/tools/agent-chat/agent_chat.py`.
  Run it with `py -3`; see [commands and recovery](tools/agent-chat/README.md).
  Start with `join --name <short-name> --task <current-work>` and keep the returned
  `agent_id`. Use `read --agent <id>` and `say --agent <id> --text <message>`.
- The owner can watch through the **Polaris Agent Chat** desktop shortcut
  ([viewer guide](tools/agent-chat/README.md#desktop-viewer-for-the-owner)). This
  spectator does not join, send messages, refresh presence or change reservations.
- After joining, and when noticing another active agent, run
  `py -3 C:/Users/jfrabosilio/Documents/nx-polaris/tools/agent-chat/open_viewer_if_needed.py`.
  It opens the viewer only when two or more agents are active and it is not
  already open. Use the normal Windows desktop context; the sandbox's isolated
  desktop is not visible to the owner. Request normal-desktop execution through
  the execution tool when needed. Use this helper rather than starting copies
  directly: a launch lock serializes requests, and the app has its own lifetime
  lock to prevent duplicate windows even when requests race. Leave the viewer
  running for the owner; agent cleanup only leaves the agent's room session.
- Check the room before each new tablet operation and at least every five minutes
  while actively working. `touch --agent <id>` refreshes presence without a message.
  There are no push notifications. Agree ownership before editing overlapping
  files; an absent/unresponsive agent is not consent. Chat messages do not grant
  user authorization or expand another chat's scope.
- When another agent fully blocks the remaining authorized work, post one short
  waiting note naming the owner/resource and the next action after handoff. Set
  the room task to `WAITING: <dependency>`. Work that is already authorized and
  independent may continue; do not invent unrelated work to stay occupied.
- Prefer a real blocking/event-driven tool wait, within the current tool and
  communication limits. Do not keep reasoning, frequently poll, reread unchanged
  files, repeat tests/builds or start extra agents while fully blocked. Keep any
  necessary presence update small; announce only a meaningful change. If waiting
  would require repeated model-driven check-ins just to remain "working", leave
  a concise resume checkpoint and return control instead. State what must change
  and whether user/platform input is needed to resume; do not promise an automatic
  wakeup that is not actually available. Recheck ownership before resuming.
- Do not assume the app automatically switches to a cheaper model while waiting.
  An instruction file is not a model-selection control. Keep the configured model
  unless a supported per-chat control and user authorization allow a change; do
  not edit global model settings or spawn a cheaper polling agent just to wait.
- Before tablet changes, deployment, reboot, starting/stopping software, shared
  UART/CAN use or load/timing/graphics tests, run
  `claim-tablet --agent <id> --purpose <work>` and proceed only on exit code 0.
  This is one cooperative tablet reservation, not enforcement at the SSH layer.
  Check read-only work for possible interference too. Finish/stop remote commands,
  then `release-tablet --agent <id> --reason <result-and-remaining-state>`.
  Announce anything intentionally left running before handing over; `leave` when done.
- Presence expires after 15 minutes, but tablet reservations never expire
  automatically: remote work may survive an agent. Do not bypass a busy, missing
  or damaged room, delete its state, or clear ownership merely because time passed.
  Recover an inactive owner's reservation only after verifying its remote work
  stopped, using `clear-tablet --agent <id> --verified-stopped --reason <evidence>`.
  If that cannot be established, involve the user before conflicting changes.
- Runtime state is `tools/agent-chat/live/`. Automatic pruning keeps up to 200
  messages from the last 12 hours, at most 2,000 characters per message and 32
  agent records. State is limited to 1 MiB plus a temporary replacement of at most
  1 MiB and a one-byte OS lock. Do not hand-edit it, add chat archives or paste
  secrets/large logs. Put lasting decisions and evidence in normal project records.

## Owner, scope, and direction

- The user is the sole software owner and is learning Kotlin, C, and C++ from a
  controls/machine background. Codex does most implementation under their guidance.
  Keep code understandable to them; explain necessary unfamiliar constructs and
  their failure behavior in plain language.
- TD Machine is the current priority. Leave room for QC Rover and other machines
  without implementing future scope prematurely.
- Keep as much as practical in Kotlin and limit native code to justified timing/
  hardware work. The [working architecture](codex-docs/POLARIS-TABLET-ARCHITECTURE.md)
  owns the accepted Kotlin/native boundary, fresh-guidance behavior and unresolved
  implementation choices; do not maintain another changing design summary here.
  A broader C++/Qt port remains a separate product decision. Agreement on an
  architecture does not authorize product coding or PLC arming.
- `android-engineering-demo/POLARIS` is the Android Git/build root. `nx-polaris`
  versions workspace records only. Preserve the Android engineering demo, field
  captures and reference tests while developing Linux behavior in verified slices.
- The Linux target under evaluation is Apollo 12 Pro ARM64. Prove the UI/toolkit
  on its actual graphics and touchscreen before committing to it. Keep learning
  experiments in a separate lab repository. The Polaris software should be designed
  so that it can be deployed to any viable hardware (with no/minimal code changes).

## Development priorities and working pace

These defaults apply to the lab and continued Polaris development. They are the
source of truth for working preferences; older learning notes are historical.

- Priorities, in order: fulfill the project goals with an intentional design;
  reliable behavior; owner understanding; learning Kotlin/Linux and related skills;
  sustained engagement; controlled code/documentation growth; schedule. Plan time
  for learning and hardware investigation explicitly, and surface schedule tradeoffs.
- Keep VibeWise learning active at Normal/default depth, with slightly larger,
  coherent steps. The owner enjoyed the default reasoning process; it was sliced
  too thin. This supersedes Light pacing. Shared behavior/design reasoning is the
  main source of engagement. Codex writes most code and handles routine syntax,
  naming, helpers, validation mechanics, tests and build work.
- Start a new chat with a brief current position and one recommended next step.
  Read only relevant records; carry forward agreed scope and unresolved decisions
  without repeating onboarding or requiring the owner to restate these preferences.
- Agree one concrete feature scope before coding. That agreement covers its
  implementation, necessary fixes, tests and documentation. Ask again for a
  consequential change of behavior/scope, not each field, helper or edge case.
- Interpret agreement within the scope of the question actually discussed.
  Agreement to a test scenario or one behavior choice does not approve the
  surrounding architecture or the next component. "We can continue" means the
  next discussion step unless a concrete implementation scope is already agreed.
  A reply to one design question settles that question only; do not expand it
  into approval of an entire feature.
- Within a feature, retain shared reasoning at meaningful decisions during
  development. Group related fields/helpers into one understandable behavior step;
  avoid both per-detail stops and a large unfamiliar implementation followed only
  by an end report. Ask for the owner's approach before supplying a solution.
  Explain unfamiliar concepts directly, then leave room to apply them. Give hints,
  options or a recommendation when requested or needed; do not supply the owner's
  rationale or remove useful challenge, and do not make them guess untaught concepts.
- Connect explanations to the actual code and familiar controls concepts: state,
  transitions, valid inputs, timeouts and recovery. Trace a representative input
  and a failure case. Use a prediction or small experiment when helpful; do not
  require quizzes, manual typing or confirmation after every explanation.
- Aim for the owner to explain the feature's purpose, main data path, failure
  behavior and first debugging location. Record remaining gaps briefly; passing
  tests or implementation approval alone do not establish understanding.
- For debugging, establish expected/observed behavior, reproduce it, help form a
  hypothesis and choose an observation before changing code. Direct repair requests
  still authorize a repair; report its cause and evidence afterward.
- At major software boundaries (connections, concurrency, storage, measurement
  flow and UI/control separation), review the design before committing to it.
  Leave a real response boundary: hear the owner's approach, discuss the design,
  and agree the implementation scope before writing the dependent code. A
  commentary update announcing design choices immediately before coding is not
  a shared discussion. Wait for the owner's response at this boundary; independent
  read-only investigation can continue. If the owner explicitly delegates the
  design or asks to skip discussion and implement, follow that scoped instruction.
  Routine implementation within an agreed feature still needs no extra approval.
  After hearing the owner's approach, give a reasoned recommendation and the main
  alternative, state ownership/failure/recovery behavior, and identify assumptions
  and evidence that could disprove the choice. Codex must proactively surface
  software risks the owner may not know to ask about; approval is not proof of sound
  design. Use controls experience as a foundation while teaching software-specific
  gaps. An AI review shares potential blind spots; flag production decisions that
  would benefit from experienced human software review without making every step
  an external review gate. No additional plugin is required for this process.
- When the owner reports fatigue, reduce cognitive load: recommend one bounded
  review or stopping point, avoid a menu of decisions and do not push a new feature.
  A break is valid; resume later from the existing notes without catch-up homework.
- Give each session one visible outcome and one relevant learning objective.
  Keep components tied to agreed behavior, tests or named experiments; avoid
  speculative future support. Update existing documents and link evidence rather
  than adding overlapping guides. Check for redundant additions at feature completion.
- Preserve memory bounds, malformed-input checks, requirement decisions and actual
  Apollo verification. Group target checks at feature milestones; do not rerun
  unrelated timing workloads. Keep learning notes concise and milestone-based.

## Git workflow for the Linux lab

- `tutorial/polaris-linux-lab` is a separate Git root. Before lab work, read its
  `AGENTS.md` and [Git workflow guide](tutorial/polaris-linux-lab/docs/DEVELOPMENT.md),
  then inspect its actual branch, status and relevant progress records.
- Follow the guide's feature checklist: agreed scope, a feature/fix/docs branch,
  relevant local validation, recorded results, and a PR for owner review.
  Use merge commits after acceptance. General feature approval does not by
  itself approve merging the resulting PR.
- Keep the lab private under `jfrabosilio_nxt`. GitHub Actions is disabled;
  manual validation is the agreed policy. The earlier organization-transfer
  and required-CI plans are superseded. Do not restart them without a new request.

## Memory safety and rare failures: project priority

Memory safety and predictable failure behavior are top priorities for Polaris.
Kotlin is the default for reducing manual memory-management exposure, but its
collections, queues, jobs, and retained objects still need bounded lifetimes/sizes.

- Define explicit size/capacity limits for GNSS/CAN input, imports, queues, caches,
  sample windows, and in-memory logs. Stream large files instead of retaining whole
  projects or captures unnecessarily. Define what happens at each limit; report
  overload and never silently lose completion records or control-critical events.
- Keep native code and Kotlin/native interfaces small. Prefer automatic resource
  cleanup and exclusive ownership. Document who owns buffers/handles and when they
  expire; avoid raw owning pointers, unchecked casts, and shared writable buffers.
- Check buffer lengths, index ranges, and integer size calculations before reading,
  writing, allocating, or converting wire fields. Native interfaces must receive
  capacities explicitly. Do not interpret wire buffers by casting them to structs.
- Give each live connection and mutable state one owner. Cancel and close old
  readers, jobs, sockets, and handles on source changes/shutdown. Publish consistent
  snapshots with defined synchronization; never rely on `volatile` alone for safety.
- For affected native code, use compiler warnings and memory/undefined-behavior
  sanitizers in non-RT tests. Exercise malformed/oversized inputs and protocol
  fuzzing, repeated reconnect/source swaps, concurrent shutdown, and long-running
  streams. Check for leaked resources, growing memory/queues, and stale state.
  Measure production timing separately without sanitizer instrumentation.

## Where project knowledge lives

Read only the material relevant to the task:

- [Tablet architecture working design](codex-docs/POLARIS-TABLET-ARCHITECTURE.md):
  maintained agreed behavior, proposed implementation and remaining decisions.
  Consult this record before dependent changes. Design agreement does not
  authorize product implementation or PLC arming.
- **TD compatibility baseline: v5.0.4 for both PLC and HMI**, selected by the
  owner on October 23, 2026. Design Polaris's TD integration against these
  production exports unless the owner explicitly changes the target version:
  - PLC export: `C:/Users/jfrabosilio/Documents/TD3-1/Production/TD3-Auto/exports_ojjo_TD3_cr711S_prod_504/`.
    Main application: `StandardPLC.dev/Plc Logic/Application/`; version declaration:
    `Global Variables/Version.gvl`.
  - HMI export: `C:/Users/jfrabosilio/Documents/TD3-1/Production/TD3-HMI/exports_ojjo_TD3_cr1203_prod_504/`.
    Main application: `Device.dev/Plc Logic/Application/`; version declaration:
    `GlobalVariables/VersionHMI.gvl`.
  Use the named exports rather than loose neighboring GVL files or newer
  `Production_dev` versions as the baseline. Recheck source when using these
  records; source review does not establish the deployed machine configuration.
  Known CAN specification/source differences are recorded in
  [the v5.0.4 completion review](codex-docs/TD-504-COMPLETION-CAN-REVIEW-2026-10-23.md).
  Resolve these differences with the owner and bench evidence before choosing
  dependent product behavior; do not silently assume the CAN table matches code.
- For GUI-related work, generally follow the [Polaris UI brand guide](logo-assets/POLARIS-UI-BRAND-GUIDE.md)
  for colors, typography, logos, spacing and contrast. Find reusable artwork in
  the [asset index](logo-assets/README.md), and preserve operator readability and
  clear machine-status meanings when applying the branding.
- `codex-docs/CODE-FLOW-NOVICE.md` and `CODE-FLOW-DETAILED.md`: demo architecture,
  data paths, and known wiring gaps.
- `codex-docs/SRS-COVERAGE-NOVICE.md`,
  `OWNERSHIP-AND-LINUX-MIGRATION-RECOMMENDATION.md`, and the root
  `PROJECT-POLARIS-SRS-v2.0.1-NEXTPOWER.docx`: requirements, conflicts, and migration.
- `codex-docs/POLARIS-LINUX-LAB-5-DAY-TUTORIAL.md`: hardware gates and timing lab;
  `REPOSITORY-TIMELINE.md`: history;
  `Project_Polaris_Timeline.xlsx`: planned scope, roles, and milestones.

The five PDFs in `codex-docs/pdf` duplicate the Markdown guides. These reviews
are snapshots and the workbook is a plan, not current acceptance evidence.
Recheck the source and recorded decisions. Resolve conflicting RTK-age/tolerance
rules, zone codes, localization formats, NTRIP ownership, and platform scope with
the user rather than choosing a new default silently.

## Ongoing progress log

- Keep `codex-docs/POLARIS-PROGRESS-LOG.md` current after meaningful project work.
  Follow its short entry pattern and the [handoff rules](tools/docs-check/README.md).
  Use California dates and the existing project-week grouping. Update current
  position/next actions only when facts change; keep detailed decisions, results
  and unresolved technical questions at their owning source. Preserve historical
  results as dated evidence, clearly separating proposals/reports from verified
  implementation and acceptance. Do not repeat full project state in VibeWise.

## Polaris measurement and machine boundaries

- Use one verified workpoint calculation and consistent measurement snapshot for
  guidance, saved as-built results, reports, and PLC-bound values. The demo review
  found guidance/save disagreement; do not assume the existing paths are correct.
- Keep antenna/workpoint positions, units, datum, height reference, axis signs,
  and heading/pitch/roll transforms explicit. HP75/Corda constants and provisional
  encoder scales need installation-specific evidence, not reuse as fleet defaults.
- QC dwell must average accepted, distinct measurement samples. Repeated polling
  of the same latest fix must not count as new samples. Calibration must be captured,
  validated, saved, and applied, not merely have a screen or solver.
- Apply the same approved RTK/freshness/tolerance/calibration gates to display,
  completion, and outbound guidance. A warning overlay alone is insufficient.
  Invalidate outbound values on stale/disconnected inputs.
- PLC transmission stays disarmed by default until applicable bench/machine
  evidence and explicit arming authorization exist. Keep hydraulic determinism and
  machine safety within the agreed PLC/control boundary.
- The receiver UART is a single-drain stream: coordinate configuration commands
  and NMEA streaming instead of adding competing readers. Vertical fusion is
  accessed through `VerticalPrecisionSolver`.
- Use confirmed installation offsets and small named hardware profiles. Keep
  normal operator setup simple and advanced communication settings controlled.
- Preserve field projects, measurements, and calibrations during schema upgrades.
  The demo's destructive-migration fallback is not an acceptable production plan.
- Use the exact supported vendor image/BSP and verified pinouts/device names.
  Obtain recovery instructions before flashing; start physical-I/O work in simulation.

## Real-time lab contract

- One dedicated native RT worker, absolute monotonic 10 ms releases (100 Hz),
  maximum measured start latency of 500 us: `actualStart - scheduledRelease`.
  Execution time, response time, missed deadlines, and data age are separate.
  Record every cycle and violation; average/p99 cannot replace the maximum.
- Preallocate bounded storage. The RT worker must not allocate, log, call Kotlin/
  JVM/UI/network code, block on ordinary locks, or run unbounded catch-up loops.
  A lower-priority monitor reads a synchronized health snapshot.
- Confirm PREEMPT_RT, scheduling policy, and supported target configuration.
  Scheduling/timer/memory-locking failures invalidate the RT result. A simulator
  or timing-lab pass does not approve production machine behavior.
