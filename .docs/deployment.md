# Deployment Guide

The workspace uses a customized PowerShell-based automation system integrated with VS Code tasks.

## Deployment Scripts

Located in `.tools/scripts/deploy/`:

- `deploy-api.ps1`: Handles .NET compilation and FTP upload for APIs.
- `deploy-ui.ps1`: Handles Angular builds (including Node versioning) and FTP upload for UIs.
- `common-lib.ps1`: Shared functions for FTP communication and configuration parsing.

## Build Artifacts

All builds are centralized in the `.tools/builds/` directory.

- Before each deployment, the specific project folder in `.tools/builds/` is cleaned.
- The compiled binaries/assets are copied there before being sent to the FTP server.
- This serves as a local history of the last successful build.

## How to Deploy

1. Open the VS Code **Command Palette** (`Ctrl+Shift+P`).
2. Type **"Tasks: Run Task"**.
3. Select either:
   - **🚀 DEPLOY: API to Test Server**
   - **🚀 DEPLOY: UI to Test Server**
4. Choose the target project from the dropdown list.

## Adding a New Project to Deployment

If a new API or UI is added:

1. Register it in `.tools/scripts/config/targets.json`.
2. Add its FTP port in `.tools/scripts/config/environments.json`.
3. Add the project ID to the corresponding `pickString` input in `.vscode/tasks.json`.
