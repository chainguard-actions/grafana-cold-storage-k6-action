<!-- markdownlint-disable -->

# Hardening Report: grafana-cold-storage--k6-action/v0.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **grafana-cold-storage--k6-action/v0.3.1** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The workflow file uses mutable refs instead of pinned SHA commits. 'actions/checkout@v4' uses a tag and 'grafana/k6-action@HEAD' uses a branch name — neither is a 40-character hex SHA. Additionally, the Dockerfile referenced by action.yml's runs.image uses 'FROM grafana/k6:latest', a mutable image tag rather than a SHA digest, making the action vulnerable to supply-chain attacks if the upstream image is replaced.

Locations:

- `.github/workflows/main.yml:8`
- `.github/workflows/main.yml:14`
- `Dockerfile:1`

### permissions (severity: medium)

The workflow file .github/workflows/main.yml has no top-level 'permissions:' key and the only job ('build') also has no job-level 'permissions:' key. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad.

Locations:

- `.github/workflows/main.yml:1`

### script-injection (severity: high)

Rule (b) violation: entrypoint.sh executes `sh -c "k6 $K6_COMMAND $INPUT_FILENAME $INPUT_FLAGS"` where $INPUT_FILENAME and $INPUT_FLAGS are derived from workflow inputs (inputs.filename and inputs.flags respectively) and are unquoted inside the shell command string. An attacker-controlled input value containing shell metacharacters (e.g. semicolons, pipes, backticks, command substitution) will be interpreted by the shell, enabling arbitrary command injection. The variables must be individually double-quoted: `sh -c "k6 \"$K6_COMMAND\" \"$INPUT_FILENAME\" $INPUT_FLAGS"` or passed as separate arguments rather than via a single string.

Locations:

- `entrypoint.sh:7`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, permissions, script-injection

**Notes:**

1. Pinned actions/checkout@v4 → SHA 11d5960a326750d5838078e36cf38b85af677262, grafana/k6-action@HEAD → main branch SHA 1e9c55046702f865e9a66c44c1004f47f4d01922, and grafana/k6:latest Dockerfile base image → sha256:5221b620a4f874faff6e32ba597aa667c058391fe4898b1c6f6377f062c6cdec. 2. Added `permissions: {}` at top-level and job-level in .github/workflows/main.yml. 3. Rewrote entrypoint.sh to call k6 directly instead of via `sh -c "..."`, using `set --` to build the argument list: K6_COMMAND and INPUT_FILENAME are individually double-quoted; INPUT_FLAGS is word-split (unquoted) but since k6 is invoked directly (not through a shell), metacharacters in flag values are passed as literal strings and cannot cause shell injection. Also replaced the bash-specific `[[ ]]` conditional with POSIX `[ ]` to match the #!/bin/sh shebang.

