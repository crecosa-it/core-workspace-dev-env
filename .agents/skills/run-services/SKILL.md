---
name: run-services
description: Procedure to start Credit Core workspace services in a local development environment (backend .NET, Angular frontends, auxiliary APIs).
---

# Skill: Run Services (Credit Core)

## Workspace Services

| Service              | Directory                   | Technology        |
|-----------------------|-----------------------------|-------------------|
| `credit-api`          | `credit-api/creApiRest`     | .NET C# (ASP.NET) |
| `backoffice-api`      | `api-backoffice/BackOfficeManager.Api`| .NET C# (ASP.NET) |
| `back-office-ui`      | `back-office-ui/`           | Angular           |
| `credit-legacy-ui`    | `credit-legacy-ui/`         | Angular           |
| `file-storage-api`    | `file-storage-api/`         | (File API)        |
| `guaranteemanagerapi` | `guaranteemanagerapirest/`  | .NET C#           |
| `reportApi`           | `reportApi/`                | Reports API       |

## Quick Start Script
The workspace includes a PowerShell script to start all services:
```powershell
.\run_all.ps1
```
Located at the root: `d:\Proyectos\Credit_Core_Work_Space\run_all.ps1`

## Manual Start by Service

### Backend .NET (`credit-api`)
```powershell
cd credit-api\creApiRest
dotnet run
# Or for watch mode (auto-reload):
dotnet watch run
```

### Frontend Angular
```powershell
cd back-office-ui   # or credit-legacy-ui
npm install         # only the first time
npm start           # or ng serve
```

## Key Environment Variables
See `credit-api/creApiRest/appsettings.json` for:
- Connection strings (MySQL at `192.168.1.85:9699`)
- JWT keys
- AWS S3 credentials

## Typical Ports (Inferred)
- `credit-api` -> check in `launchSettings.json`
- Angular apps -> `4200` by default (`ng serve`)

## Common Troubleshooting
- If DB connection fails: verify that `192.168.1.85:9699` is accessible on the local network.
- If `npm install` fails: verify Node.js version (requires v18+, currently v25).
- If JWT fails: ensure that `JWT_SECRET_KEY` in `appsettings.json` matches between services.
