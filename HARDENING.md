<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/release-20241102143619

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **elgohr--Github-Release-Action/release-20241102143619** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In entrypoint.sh, the shell variable $INPUT_TAG is expanded **unquoted** in the command `gh release create $INPUT_TAG -t "${INPUT_TITLE}" --generate-notes"${OPTIONS}"`. INPUT_TAG is populated from `inputs.tag` (an attacker-controlled composite-action input) via the env block in action.yml. An attacker can supply a value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) that the shell will interpret before `gh` ever sees them, enabling arbitrary command injection. The fix is to quote the expansion: `"$INPUT_TAG"`.

Locations:

- `entrypoint.sh:16`
- `action.yml:31`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in entrypoint.sh by quoting the $INPUT_TAG variable in the `gh release create` command (line 16). Changed `$INPUT_TAG` to `"$INPUT_TAG"` so that shell metacharacters in the attacker-controlled `inputs.tag` value cannot be interpreted by the shell, preventing arbitrary command injection.

