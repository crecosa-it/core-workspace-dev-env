---
description: Reviews and ensures the consistency of the workspace configuration (repositories added in docs, config, vscode, tools), preventing deleted services from leaving garbage or new services from going undocumented. Must not leak secrets.
---

# Skill: Workspace Consistency

## Objective

Analyze the main project folders and identify discrepancies between the actual directories (APIs, UIs) and the various sources of truth in the `core-workspace-dev-env`. This skill must be invoked whenever an API or UI is removed or introduced to the workspace.

## Consistency Evaluation Rules

When asked to evaluate workspace consistency or apply this skill, follow this rigorous step-by-step checklist:

### 1. Physical Directory Scan (`list_dir`)

*   Use tools like `list_dir` in the root directory (`Credit_Core_Work_Space`) to obtain the current list of repositories or subfolders.
*   Identify all folders with the `api-*` and `ui-*` prefixes.

### 2. Source Cross-Check

Verify that ALL the prefixed and active folders discovered above exist strictly in the following locations:

1.  **VSCode Workspace:** `.vscode/tasks.json` and in the root `manage-credits.code-workspace` (under `folders` and `settings.git.scanRepositories`).
2.  **Architecture Documentation:** `.docs/architecture.md` (In the Backend/Frontend component lists).
3.  **Environment Map:** `.docs/environments.md` (Must have a row in the table and an assigned port if it runs locally).
4.  **Agent Skills & Instructions:** `.agent/agent.md` (Standard project resource listing).
5.  **Tools & Scripts:** `.tools/scripts/config/targets.json` (Must be mapped for CI/CD tools).
6.  **Orchestrators (If applicable):** Search for and verify references in `docker-compose.yml`, `.gitignore`, and PowerShell scripts (`.ps1`).

### 3. Cleanup Criteria (Purge)

*   If a folder has been deleted or its logic is obsolete, it MUST be purged from **all** the files listed in Step 2. Use global `grep_search` (with flags to search hidden files if necessary) to ensure complete eradication of the orphaned service's footprint.

### 4. 🚨 Security and Secrets Rules

*   **Never exfiltrate, expose, or write** real secrets (passwords, private connection strings, AWS keys, JWT tokens, unauthorized plain-text internal IPs) in the output reports of this skill.
*   If a script or docker-compose file contains hardcoded secrets (e.g., `password=...`), ignore them during the structural consistency evaluation. Focus solely on **service names, ports, and architecture**.

## Expected Output

After running this skill, the assistant must output a final structured report listing:

1.  The specific discrepancies found (e.g., "`api-x` is in the root directory but missing in the README").
2.  The automated actions taken (which exact files were updated to repair the inconsistency).
3.  Warnings about potential orphaned repositories or lingering configurations.
