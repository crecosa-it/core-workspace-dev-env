# Environment Map

This document tracks the network and environment requirements for the Credit Core project.

## Server Infrastructure

- **Development Server IP**: `192.168.1.177`
- **Database Server IP**: `192.168.1.85:9699`

## Application Ports (FTP & Services)

Each application runs on its own isolated IIS/FTP instance on the development server.

| Project ID      | FTP Port | Type       | Description              |
| :-------------- | :------- | :--------- | :----------------------- |
| `api-credit`    | 1001     | .NET API   | Main Credit Core API     |
| `ui-legacy`     | 1002     | Angular UI | CoreUI Legacy Dashboard  |
| `api-report`    | 1003     | .NET API   | Reporting Service        |
| `ui-backoffice` | 1004     | Angular UI | Internal Admin Tools     |
| `api-guarantee` | 1006     | .NET API   | Guarantee Management API |


## Local Environment Requirements

### Node.js Versions

- **`ui-legacy`**: **v14.17.3** (Mandatory). Use `nvm use 14.17.3` before building.
- **`ui-backoffice`**: v18.0.0+ (Modern).

### .NET Versions

- **Current APIs**: Transitioning to **.NET 10 (Preview)**.
- **Legacy Projects**: Some modules may still use **.NET 7**.

## Authentication

- **Global Deployment User**: `administrador`
- **Database User**: `admin`
