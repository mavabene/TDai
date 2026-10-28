# TD3 TODO

Maintained project work list. Add a chat name when an item has a dedicated chat;
keep technical evidence in the linked owning record.

## Deferred

- [ ] **F-01 — Review and resolve the unassigned pitch-correction term in `GpsSetTargets`.**
  - **Chat:** Review GPS pitch correction in GpsSetTargets
  - **Chat ID:** `01a17fca-ee69-7372-8eb7-4ff345f72221`
  - **Status:** Deferred until the owner resumes that chat; added October 27, 2026.
  - **Evidence:** [Initial assessment, F-01](docs/ASSESSMENT-2026-10-27.md#f-01--pitch-coupling-uses-a-value-not-assigned-in-the-function-body).
  - **Next action:** Derive the intended coupled X/Z correction and confirm frames,
    signs, and the relevant pitch angle before proposing code. Follow the owner's
    review-and-copy/paste workflow with exact paste locations.

- [ ] **F-03 — Review and resolve the unreachable `ET2_TEST = 86` reset branch.**
  - **Chat:** No dedicated chat yet.
  - **Status:** Deferred; added October 27, 2026.
  - **Evidence:** [Initial assessment, F-03](docs/ASSESSMENT-2026-10-27.md#f-03--et2-test-value-86-cannot-reach-its-stated-reset-branch).
  - **Next action:** Establish which component vectors test mode 86 should clear
    and its expected exit behavior before proposing a correction. The earlier
    `ET2_TEST > 70` branch catches 86 and returns before the reset logic.
