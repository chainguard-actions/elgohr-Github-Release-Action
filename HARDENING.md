<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/release-20241111151247

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **elgohr--Github-Release-Action/release-20241111151247** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b): In entrypoint.sh line 17, the shell variable $INPUT_TAG is expanded unquoted in the command `gh release create $INPUT_TAG -t "${INPUT_TITLE}" $OPTIONS`. INPUT_TAG is sourced from the untrusted `inputs.tag` action input (mapped via `env: INPUT_TAG: ${{ inputs.tag }}` in action.yml). An attacker can supply a value containing shell metacharacters (e.g. spaces, semicolons, backticks, `$(...)`) to inject arbitrary shell commands. The fix is to quote the variable: `gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" $OPTIONS`.

Locations:

- `entrypoint.sh:17`
- `action.yml:25`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in entrypoint.sh line 17 by quoting $INPUT_TAG. Changed `gh release create $INPUT_TAG` to `gh release create "$INPUT_TAG"` to prevent shell metacharacters in the `inputs.tag` action input from being interpreted as shell commands.

