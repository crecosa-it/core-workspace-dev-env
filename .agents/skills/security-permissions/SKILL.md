---
name: security-permissions
description: Architecture and management of the permission system (RBAC) in Credit Core.
---

# Security and Permissions System (RBAC)

This document describes the functioning of the Role-Based Access Control (RBAC) system for the Backend (.NET API) and the Frontend (Angular).

## 1. Database Structure

The system is based on 4 main tables that define the scope and allowed actions:

| Table | Purpose |
| :--- | :--- |
| `SG_ROLES` | Role catalog (1: Admin, 2: Manager, 9: Analyst, 10: Agency Head, etc.) |
| `SG_PERMISOS` | Atomic actions defined by `RECURSO` (e.g., `credit-request`) and `ACCION` (e.g., `read`). |
| `SG_PERMISOS_X_OBJETO` | **The Bridge**. Associates a Role with an application context (`ID_OBJETO`). |
| `SG_ROLES_PERMISOS` | Links an `SG_PERMISOS_X_OBJETO` record with multiple `SG_PERMISOS`. |

### The `CRE_API` Context
For Backend security, the system filters exclusively by the object **`CRE_API`**. Without a record in `SG_PERMISOS_X_OBJETO` linked to this object ID, the API will not load permissions for that role, denying access by default.

## 2. Backend Security (API)

### `[RequiresPermission]` Attribute
Used in Controllers or Methods to restrict access.
```csharp
[RequiresPermission("credit-request.read")]
public async Task<IActionResult> GetRequests() { ... }
```

### Validation Flow (`PermissionMiddleware`)
1. The middleware extracts the `RoleId` from the JWT.
2. `AuthenticationServices.GetRolesAndPermissions` queries the DB:
   `ROLES` -> `PERMISOS_X_OBJETO (where ID_OBJETO = 'CRE_API')` -> `ROLES_PERMISOS` -> `PERMISOS`.
3. Concatenation: Permissions are loaded into cache as `Resource.Action`.
4. The middleware verifies if the attribute's permission exists in the user's set.

## 3. Frontend Security (Angular)

### Screen Tables
For visual control of buttons/sections, the same `SG_PERMISOS` engine is used but with resources dedicated to screens (e.g., `RECURSO = 'CRE_SOL_LINEA'`).

### Permission Service
The `PermissionsService` consumes the endpoint `GET /api/authentication/permissions/{screenCode}`.
- The API returns a dictionary of allowed actions for the current role on that screen.
- The component uses `hasAction('SCREEN_CODE', 'ACTION_CODE')` to show/hide elements.

## 4. How to Add a New Permission

1. **Insert into `SG_PERMISOS`**: Define the Resource and the Action.
2. **Identify the Bridge**: Find the role's `ID` in `SG_PERMISOS_X_OBJETO` for the `CRE_API` object.
3. **Link in `SG_ROLES_PERMISOS`**: Insert the relationship between the bridge ID and the permission ID.

> [!IMPORTANT]
> Permissions are cached in the API for 10 minutes. For immediate changes during development, restarting the API service is recommended.
