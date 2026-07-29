<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/v5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **elgohr--Github-Release-Action/v5** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files reference actions using mutable tags or branch names instead of full 40-character commit SHAs. This exposes the workflow to supply-chain attacks if the referenced tag or branch is updated with malicious code.

Failing references:
- assign.yml: `uses: pozil/auto-assign-issue@v2` (tag)
- release.yml: `uses: actions/checkout@v4` (tag, appears 3 times)
- release.yml: `uses: elgohr/Github-Release-Action@main` (branch, appears 2 times)

Locations:

- `.github/workflows/assign.yml:9`
- `.github/workflows/release.yml:14`
- `.github/workflows/release.yml:24`
- `.github/workflows/release.yml:26`
- `.github/workflows/release.yml:33`
- `.github/workflows/release.yml:38`

### permissions (severity: medium)

Two workflow files are missing required permissions declarations:

1. `assign.yml` has NO top-level `permissions:` key and its only job (`auto-assign`) also has no job-level `permissions:` key. Without explicit permissions, the job inherits the default (often write-all) token permissions.

2. `release.yml` has job-level permissions on `unit-test` and `integration-test`, but the `release` job has NO `permissions:` key, so it inherits default token permissions rather than the minimal set needed.

Locations:

- `.github/workflows/assign.yml:1`
- `.github/workflows/release.yml:32`

### script-injection (severity: high)

Rule (b) violation: In `entrypoint.sh` (the composite action's run script), the variables `$INPUT_TAG` and `$OPTIONS` are expanded **unquoted** in the shell command:

    gh release create $INPUT_TAG -t "${INPUT_TITLE}" $OPTIONS

`INPUT_TAG` is set from `inputs.tag` (workflow-controllable) and `OPTIONS` is built from `INPUT_PRERELEASE` (also workflow-controllable). Unquoted shell expansion allows an attacker to inject shell metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, glob chars) through these inputs, achieving command injection. Both variables should be double-quoted: `"$INPUT_TAG"` and `"$OPTIONS"`.

Locations:

- `entrypoint.sh:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, permissions, script-injection

**Notes:**

Fixed all three findings:

1. **unpinned-uses**: Pinned all action references to full commit SHAs with tag comments preserved:
   - `pozil/auto-assign-issue@v2` → `@7bf9d82c77d45976224660b873fc83e60576c5aa # v2` (assign.yml)
   - `actions/checkout@v4` → `@11d5960a326750d5838078e36cf38b85af677262 # v4` (release.yml, 3 occurrences)
   - `elgohr/Github-Release-Action@main` → `@c552071f9147ab82a7ddbc90651a8d81d24e2085 # main` (release.yml, 2 occurrences)

2. **permissions**: Added explicit permissions blocks:
   - `assign.yml`: Added top-level `permissions: {}` and job-level `permissions: issues: write` (needed for auto-assigning issues)
   - `release.yml`: Added `permissions: contents: write` to the `release` job (needed for git tag push)

3. **script-injection**: Rewrote `entrypoint.sh` to eliminate unquoted variable expansion:
   - `$INPUT_TAG` is now properly double-quoted as `"$INPUT_TAG"`
   - The `$OPTIONS` string variable (which required word-splitting) was replaced with POSIX `set --` positional parameters, building the argument list safely without relying on word-splitting of user-influenced variables. Each flag (`--generate-notes`, `--prerelease`) is added as a separate positional parameter and passed via `"$@"`.

