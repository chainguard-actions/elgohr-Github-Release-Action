<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/release-20241102141725

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **elgohr--Github-Release-Action/release-20241102141725** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b): In entrypoint.sh (called by action.yml), the shell variable $INPUT_TAG — which is sourced from the untrusted composite action input `inputs.tag` via the env block — is expanded unquoted in the command `gh release create $INPUT_TAG -t "${INPUT_TITLE}" --generate-notes`. An attacker controlling the `tag` input can inject shell metacharacters (e.g. semicolons, pipes, command substitution) to execute arbitrary commands on the runner.

Locations:

- `entrypoint.sh:11`
- `action.yml:20`

### unpinned-uses (severity: high)

Multiple `uses:` references in release.yml are pinned to mutable tags or branches rather than immutable 40-character commit SHAs, making the workflow vulnerable to supply-chain attacks: `actions/checkout@v4` (appears 3 times) and `elgohr/Github-Release-Action@main` (appears 2 times).

Locations:

- `.github/workflows/release.yml:14`
- `.github/workflows/release.yml:20`
- `.github/workflows/release.yml:26`
- `.github/workflows/release.yml:33`

### unpinned-uses (severity: high)

The `uses:` reference in assign.yml is pinned to a mutable tag rather than an immutable 40-character commit SHA: `pozil/auto-assign-issue@v2`. This is vulnerable to supply-chain attacks if the tag is moved.

Locations:

- `.github/workflows/assign.yml:8`

### missing-permissions (severity: medium)

release.yml has no top-level `permissions:` key, and the `release` job also has no job-level `permissions:` key. This means the release job runs with the default (potentially broad) GITHUB_TOKEN permissions. Every job must have explicit minimal permissions.

Locations:

- `.github/workflows/release.yml:1`

### missing-permissions (severity: medium)

assign.yml has no top-level `permissions:` key and the `auto-assign` job has no job-level `permissions:` key. The workflow runs with default GITHUB_TOKEN permissions, which may be broader than necessary.

Locations:

- `.github/workflows/assign.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

Fixed 5 findings across 4 files:
1. entrypoint.sh: Quoted `$INPUT_TAG` → `"$INPUT_TAG"` to prevent shell metacharacter injection.
2. release.yml: Pinned `actions/checkout@v4` → SHA `34e114876b0b11c390a56381ad16ebd13914f8d5` (3 occurrences), `elgohr/Github-Release-Action@main` → SHA `c552071f9147ab82a7ddbc90651a8d81d24e2085` (2 occurrences). Added top-level `permissions: {}` and explicit `permissions: contents: write` on the release job.
3. assign.yml: Pinned `pozil/auto-assign-issue@v2` → SHA `7bf9d82c77d45976224660b873fc83e60576c5aa`. Added top-level `permissions: {}` and job-level `permissions: issues: write` for the auto-assign job.

