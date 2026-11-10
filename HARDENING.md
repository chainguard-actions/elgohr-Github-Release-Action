<!-- markdownlint-disable -->

# Hardening Report: elgohr--Github-Release-Action/v5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **elgohr--Github-Release-Action/v5** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b): in entrypoint.sh, which the composite step's run: block runs, the workflow-controlled INPUT_TAG (from inputs.tag) is expanded without quotes: `gh release create $INPUT_TAG -t "${INPUT_TITLE}" $OPTIONS`. The shell splits the value on whitespace and expands globs, so a crafted tag can add extra arguments or flags to `gh release create`. Fix: quote it as "$INPUT_TAG". OPTIONS is built inside the script from fixed strings, so it is not affected.

Locations:

- `entrypoint.sh:17`

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
index 9e7ad24..70eb589 100755
--- a/entrypoint.sh
+++ b/entrypoint.sh
@@ -9,12 +9,12 @@ main() {
         INPUT_TAG="release-$(date +%Y%m%d%H%M%S)"
     fi
 
-    OPTIONS="--generate-notes"
+    set -- --generate-notes
     if usesBoolean "${INPUT_PRERELEASE}"; then
-        OPTIONS="${OPTIONS} --prerelease"
+        set -- "$@" --prerelease
     fi
 
-    gh release create $INPUT_TAG -t "${INPUT_TITLE}" $OPTIONS
+    gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" "$@"
 }
 
 uses() {

```

Locations:

- `entrypoint.sh`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, prior-fix

**Notes:**

entrypoint.sh: INPUT_TAG is now quoted. OPTIONS is replaced with POSIX 'set --' positional parameters (--generate-notes, plus --prerelease when requested), expanded as "$@". The script stays sh-compatible. action.yml: re-applied the prior whitespace cleanup and quoted the entrypoint path in run:.

