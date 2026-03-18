# Credit Core Workspace - Development Environment (core-workspace-dev-env)

This repository contains the global configurations, scripts, documentation, and infrastructure (such as Docker Compose) required to run and manage the local development environment for the **Credit Core** project.

> **Note:** This environment repository explicitly ignores the actual code projects (APIs and UIs). Each microservice (API) and frontend application (UI) is managed in its own dedicated repository.

## 📂 What's inside this repository?

- **Docker Configuration (`docker-compose.yml`, `init-db.sql`):** Easily spin up the required local databases and infrastructure services.
- **Initialization and Synchronization scripts:** Python (`process_sync.py`), PowerShell (`run_all.ps1`), and SQL (`sync_permissions.sql`) scripts to automate database setup or run background services.
- **IDE Workspace files:** General configuration files (like `manage-credits.code-workspace` or the `.vscode/` setup) to integrate all sub-repositories into a unified project view.
- **Agent Rules (`.agent/`):** Custom AI agent skills and configurations (`db-tools`, `skills`).
- **Documentation (`.docs/`):** High-level global project architecture and deployment manuals.
- **Deployment Tools (`.tools/`):** Scripts and configurations to automate local deployments or environment validations.

## 🚀 Getting Started (Local Setup)

1. **Clone this base repository:**
   Make sure to clone this repository into what will become the root folder containing all Credit Core projects.
   ```bash
   git clone git@github.com:crecosa-it/core-workspace-dev-env.git Credit_Core_Work_Space
   cd Credit_Core_Work_Space
   ```

2. **Clone API and UI repositories (inside this directory):**
   APIs (e.g., `api-credit`, `api-backoffice`) and UIs (e.g., `ui-legacy`, `ui-backoffice`) must be cloned directly into this root folder. These subdirectories are properly ignored by the root `.gitignore`.

3. **Start the local infrastructure:**
   Depending on what you need to test, bring up the necessary services (databases, message brokers, etc.):
   ```bash
   docker-compose up -d
   ```

## 📝 Usage Rules

- **Do not commit application code here.** This repository is strictly for *Workspace* configurations, orchestration, and global scripts.
- Any new environment setup scripts or automation tools should be added here so they can be securely shared across the entire engineering team.
