# Workspace Instructions - Credit Core

This file contains persistent rules and preferences for the Antigravity agent in this project.

## Project Overview

Credit Core is a comprehensive financial management system for Crecosa, designed to handle credit requests, financial evaluations, and institutional reporting.

## Project Structure (New Standard)

- **APIs**: `api-credit`, `api-report`, `api-guarantee`.
- **UIs**: 
  - `ui-legacy`: Main operational dashboard (Angular 11, Node 14).
  - `ui-backoffice`: Internal administrative tools (Modern Angular).

## Architecture & Security

Refer to [.docs/architecture.md](file:///d:/Proyectos/Credit_Core_Work_Space/.docs/architecture.md) for detailed information on Vertical Slice Architecture and the Security (RBAC) system.

## Dynamic Menu System

The navigation menu in Credit Core is context-aware and driven by the database:
- **Structure**: Defined in `PA_MENU_ENCA` (categories) and `PA_MENU_DETA` (items).
- **Security Mapping**: Linked to roles via `SG_MENU_ENCA` and `SG_MENU_DETA`.
- **Platform Separation**: Filtered by `PA_DET_APLI_MENUDETA` using an `ID_APLICACION` (e.g., `WEB`, `BACK`).
- **Flow**: User Login -> Get Role -> Fetch Menus where (Role + Application) match -> Build UI Sidebar.

## Jira Rules

- **Default Project**: When asked to create, review, or list Jira tasks without a project code, assume **Credit Core (CC)**.
- **Queries**: Prioritize results from project `CC` when searching for recent tickets.

## Databases (MySQL/MariaDB at 192.168.1.85:9699)

| DB Name                | Purpose                                        |
|------------------------|------------------------------------------------|
| `ctpagabd`             | Main Credit Core / CTPaga database             |
| `SMCF_COBRO`           | Collections and debt management                |
| `simicrofin_crecosa`   | Legacy Crecosa microfinance system             |
| `guaranteedb`          | Guarantee management                           |
| `dbreportes`           | Reporting and dashboards                       |

- **Credentials**: User `admin`, password in the API config.
- **MCP Active**: The `database` MCP server connects to `ctpagabd` by default. To query another DB, prefix the table name (e.g., `SMCF_COBRO.table`).
- **Safety**: DB credentials should only be used for reading/analyzing data. Never modify production data without explicit user confirmation.

## AI Interaction Guidelines

- **Vertical Slices**: When adding features, keep all related logic (DTOs, Services, Controllers) within the same Feature folder.
- **Security Check**: Every new endpoint MUST be evaluated against the Permission System. Never use `AllowPermissionFree` unless explicitly authorized.
- **Data Integrity**: Prefer LINQ for database operations. Ensure complex queries use `.AsNoTracking()` where appropriate.
