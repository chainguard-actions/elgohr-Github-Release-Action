<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/release-20241111151247

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **elgohr--Github-Release-Action/release-20241111151247** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files reference actions by mutable tag or branch instead of a full 40-character commit SHA, making them vulnerable to supply-chain attacks if the tag is moved.

- .github/workflows/assign.yml: `uses: pozil/auto-assign-issue@v2` (tag)
- .github/workflows/release.yml: `uses: actions/checkout@v4` (tag, appears 3 times)
- .github/workflows/release.yml: `uses: elgohr/Github-Release-Action@main` (branch, appears 2 times)

All of these should be pinned to a full SHA digest, e.g. `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`.

Locations:

- `.github/workflows/assign.yml:8`
- `.github/workflows/release.yml:12`
- `.github/workflows/release.yml:22`
- `.github/workflows/release.yml:27`
- `.github/workflows/release.yml:32`
- `.github/workflows/release.yml:42`

### missing-permissions (severity: medium)

Two workflow files are missing `permissions:` blocks on one or more jobs:

- `.github/workflows/assign.yml`: No top-level `permissions:` key and the only job (`auto-assign`) has no job-level `permissions:` key. This defaults to the repository's default token permissions, which may be overly broad.
- `.github/workflows/release.yml`: The `release` job has no `permissions:` key (the other two jobs do have job-level permissions). The `release` job runs `git push` and should declare minimal required permissions explicitly.

Locations:

- `.github/workflows/assign.yml:1`
- `.github/workflows/release.yml:36`

### script-injection (severity: high)

Sub-rule (b) violation: In `entrypoint.sh` (called from `action.yml`), the variables `$INPUT_TAG` and `$OPTIONS` are expanded **unquoted** in the shell command `gh release create $INPUT_TAG -t "${INPUT_TITLE}" $OPTIONS`. 

- `INPUT_TAG` is set from `inputs.tag` (workflow-controllable) via the `env:` block in `action.yml`. An attacker-controlled value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) will be word-split and interpreted by the shell.
- `$OPTIONS` is built from `INPUT_PRERELEASE` (also workflow-controllable) and is likewise unquoted.

Both variables must be double-quoted: `gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" $OPTIONS` (and `$OPTIONS` should be handled via an array or quoted expansion).

Locations:

- `entrypoint.sh:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, script-injection

**Notes:**

1. unpinned-uses: Pinned pozil/auto-assign-issue@v2 → @7bf9d82c77d45976224660b873fc83e60576c5aa, actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262, and elgohr/Github-Release-Action@main → @c552071f9147ab82a7ddbc90651a8d81d24e2085 in both workflow files. Original tags/branches preserved as inline comments.
2. missing-permissions: Added top-level `permissions: {}` and job-level `permissions: { issues: write }` to assign.yml. Added `permissions: { contents: write }` to the release job in release.yml (needed for git push/tag operations).
3. script-injection: Fixed entrypoint.sh by double-quoting `$INPUT_TAG` in the `gh release create` call and eliminating the unquoted `$OPTIONS` variable by restructuring the conditional logic — the prerelease flag is now passed directly as a literal argument based on the boolean check, removing any unquoted variable expansion.

