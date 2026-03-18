# Credit Core Architecture

## Technology Stack

### Backend

- **Framework**: .NET 8 / .NET 10 (Preview).
- **Architecture**: **Vertical Slice Architecture**.
- **Folders**: `api-credit`, `api-report`, `api-guarantee`, `api-storage`.

### Frontend

- **UI Legacy (`ui-legacy`)**:
  - **Framework**: Angular 11.
  - **Environment**: **Node.js v14.17.3** (Requirement).
- **BackOffice (`ui-backoffice`)**:
  - **Framework**: Modern Angular (v17+).
  - **Environment**: Modern Node.js.

## Directory Structure (Features)

Each API feature is self-contained within its `Features/` folder:

- **Presentation**: Controllers and DTOs.
- **Application**: Business logic, services, and commands.
- **Domain**: Entities and repository contracts.

## Security Layer

Access is controlled via a custom Role-Based Access Control (RBAC) system.

- **Middleware**: `PermissionMiddleware` intercepts requests and validates JWT claims against database-defined permissions.
- **Attributes**: `[RequiresPermission]` and `[AllowPermissionFree]`.

## Frontend Integration

The frontend applications (`ui-legacy`, `ui-backoffice`) consume the API and use a dynamic permission service to hide or show UI elements based on the backend's response for specific screen codes.

## Database Pattern

We use **Entity Framework Core** for most operations. Complex filtering, such as the office-based data isolation, is implemented at the Service layer to ensure consistency between lists and summaries.
