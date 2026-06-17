<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/release-20241102141725

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **elgohr--Github-Release-Action/release-20241102141725** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In entrypoint.sh, the shell variable $INPUT_TAG is expanded unquoted in the `gh release create` command (`gh release create $INPUT_TAG -t "${INPUT_TITLE}" --generate-notes`). INPUT_TAG is set from `${{ inputs.tag }}` (an untrusted caller-controlled input) via the env: block in action.yml. An unquoted expansion allows shell metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, glob chars) in the tag value to be interpreted by the shell, enabling command injection. The fix is to quote the variable: `gh release create "$INPUT_TAG" ...`.

Locations:

- `entrypoint.sh:11`
- `action.yml:21`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in entrypoint.sh line 11: changed unquoted `$INPUT_TAG` to quoted `"$INPUT_TAG"` in the `gh release create` command. The INPUT_TAG variable is set from the caller-controlled `inputs.tag` input via the env: block in action.yml. Without quoting, shell metacharacters in the tag value could be interpreted as shell commands. The fix ensures the tag value is always treated as a single literal argument.

