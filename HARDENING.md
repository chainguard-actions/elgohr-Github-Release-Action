<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/release-20241111151247

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **elgohr--Github-Release-Action/release-20241111151247** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. Sub-rule (b) violation: In `entrypoint.sh` (called from `action.yml`), the variables `$INPUT_TAG` and `$OPTIONS` are expanded **unquoted** in the shell command `gh release create $INPUT_TAG -t "${INPUT_TITLE}" $OPTIONS`. 

- `INPUT_TAG` is set from `inputs.tag` (workflow-controllable) via the `env:` block in `action.yml`. An attacker-controlled value containing shell metacharacters (`;`, `|`, `$(...)`, etc.) will be word-split and interpreted by the shell.
- `$OPTIONS` is built from `INPUT_PRERELEASE` (also workflow-controllable) and is likewise unquoted.

Both variables must be double-quoted: `gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" $OPTIONS` (and `$OPTIONS` should be handled via an array or quoted expansion).

Locations:

- `entrypoint.sh:16`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yml b/action.yml
index 739a26d..20c5c63 100644
--- a/action.yml
+++ b/action.yml
@@ -4,7 +4,6 @@ branding:
   icon: "git-branch"
   color: "gray-dark"
 description: "Publish Github releases from an action"
-
 inputs:
   title:
     description: "The name of the release to publish"
@@ -18,10 +17,26 @@ inputs:
   prerelease:
     description: "Publishes a prerelease"
     required: false
-
 runs:
   using: 'composite'
-  steps:      
+  steps:
     - run: $GITHUB_ACTION_PATH/entrypoint.sh
       shell: bash
       env:

```

Locations:

- `action.yml`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed entrypoint.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/entrypoint.sh b/entrypoint.sh
index 9e7ad24..39ac601 100755
--- a/entrypoint.sh
+++ b/entrypoint.sh
@@ -9,12 +9,11 @@ main() {
         INPUT_TAG="release-$(date +%Y%m%d%H%M%S)"
     fi
 
-    OPTIONS="--generate-notes"
     if usesBoolean "${INPUT_PRERELEASE}"; then
-        OPTIONS="${OPTIONS} --prerelease"
+        gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" --generate-notes --prerelease
+    else
+        gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" --generate-notes
     fi
-
-    gh release create $INPUT_TAG -t "${INPUT_TITLE}" $OPTIONS
 }
 
 uses() {

```

Locations:

- `entrypoint.sh`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, prior-fix

**Notes:**

entrypoint.sh: the tag is now quoted as "$INPUT_TAG". The unquoted $OPTIONS string is gone; the script now has two separate gh release create calls, one with --prerelease and one without. This matches the previous harden's patch. action.yml: I re-applied the previous whitespace cleanup and also quoted the script path ("$GITHUB_ACTION_PATH/entrypoint.sh"). The inputs are still passed in through env:. Nothing was run or tested in this pass.

