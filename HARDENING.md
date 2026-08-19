<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/release-20241102143619

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **elgohr--Github-Release-Action/release-20241102143619** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

assign.yml has no top-level `permissions:` key and the `auto-assign` job also has no job-level `permissions:` key. This means the workflow runs with default (potentially broad) permissions.

Locations:

- `.github/workflows/assign.yml:1`

### missing-permissions (severity: medium)

release.yml has no top-level `permissions:` key, and the `release` job has no job-level `permissions:` key (only `unit-test` and `integration-test` jobs have job-level permissions). The `release` job runs with default permissions.

Locations:

- `.github/workflows/release.yml:34`

### unpinned-uses (severity: high)

assign.yml references `pozil/auto-assign-issue@v2` — a mutable tag ref, not a pinned full-length commit SHA. This is vulnerable to supply-chain attacks if the tag is moved.

Locations:

- `.github/workflows/assign.yml:8`

### unpinned-uses (severity: high)

release.yml contains multiple unpinned `uses:` references: `actions/checkout@v4` (lines ~14, 24, 37) and `elgohr/Github-Release-Action@main` (lines ~26, 33). Tags and branch names are mutable and vulnerable to supply-chain attacks. All references should be pinned to a full 40-character commit SHA.

Locations:

- `.github/workflows/release.yml:14`
- `.github/workflows/release.yml:24`
- `.github/workflows/release.yml:26`
- `.github/workflows/release.yml:33`
- `.github/workflows/release.yml:37`

### script-injection (severity: high)

Rule (b) violation: In entrypoint.sh (called by action.yml's composite run step), the variable `$INPUT_TAG` is expanded unquoted in the shell command `gh release create $INPUT_TAG -t "${INPUT_TITLE}" --generate-notes"${OPTIONS}"`. `INPUT_TAG` is set from `${{ inputs.tag }}` via the action.yml env block. An attacker-controlled value in `inputs.tag` containing shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) can break out of the argument and inject arbitrary shell commands. The fix is to quote the variable: `gh release create "$INPUT_TAG" ...`.

Locations:

- `entrypoint.sh:16`
- `action.yml:22`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions, unpinned-uses, script-injection

**Notes:**

Fixed all 5 findings: (1) assign.yml: added top-level `permissions: {}` and job-level `permissions: issues: write`, pinned pozil/auto-assign-issue@v2 to SHA 7bf9d82c77d45976224660b873fc83e60576c5aa; (2) release.yml: added `permissions: contents: write` to the `release` job, pinned actions/checkout@v4 to SHA 11d5960a326750d5838078e36cf38b85af677262 (3 occurrences) and elgohr/Github-Release-Action@main to SHA c552071f9147ab82a7ddbc90651a8d81d24e2085 (2 occurrences); (3) entrypoint.sh: quoted `$INPUT_TAG` as `"$INPUT_TAG"` in the gh release create command to prevent script injection via shell metacharacters.

