---
name: code-review
description: Checklist and code conventions for the Credit Core project. Covers the .NET C# backend (credit-api) and the Angular frontend (credit-legacy-ui, back-office-ui).
---

# Skill: Code Review (Credit Core)

## Technological Stack
- **Backend**: .NET C# with Features architecture (Vertical Slice)
- **Frontend**: Angular (TypeScript), with DevExtreme as the component library
- **Database**: MySQL/MariaDB via Entity Framework or Dapper
- **Auth**: JWT with UserId and role claims
- **Storage**: AWS S3 (bucket `crecosa-credit`, region `us-east-2`)
- **Tests**: `creApiRest.Tests` project

## Backend Conventions (C#)

### Features Structure
```
Features/
  [FeatureName]/
    Application/
      Commands/     ← Write commands (CQRS)
      Queries/      ← Read queries
      DTOs/         ← Data transfer objects
      Utilities/    ← Validations, business rules
    Domain/
      Entities/     ← Domain entities
      Interfaces/   ← Repository contracts
```

### Code Rules
- Use DTOs for controller input/output, never expose entities directly.
- `UserId` must be obtained from the JWT (claims) in the service, not passed from the frontend.
- Business rule validations should reside in `Utilities/Validation/Rules`.
- DB connections are handled via `ConnectionStrings` in `appsettings.json`.

## Frontend Conventions (Angular)

### Structure
- Permission services must be consulted before showing actions in the UI.
- Use `DevExtreme` for tables, forms, and modals.
- Dashboard states must be consistent with those of the API.

## Code Review Checklist

### General
- [ ] Does the code follow the established Features structure?
- [ ] Are DTOs used in the endpoints?
- [ ] Are errors handled and returning appropriate HTTP codes?
- [ ] Are variable and method names descriptive?

### Security
- [ ] Does the UserId come from the JWT, not the request body?
- [ ] Do private endpoints have `[Authorize]`?
- [ ] Are there no hardcoded credentials in the code?

### Database
- [ ] Are queries parameterized (anti SQL injection)?
- [ ] Are migrations backward compatible?

### Tests
- [ ] Were tests added for the new logic?
