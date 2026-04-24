# Diagrama de Flujo: Operatoria de la Billetera

Este diagrama ilustra el flujo principal desde el registro del cliente (Onboarding), la gestión en el BackOffice, hasta el proceso de recarga de saldo con su respectiva aprobación.

```mermaid
graph TD
    %% Onboarding
    A[App Móvil: Cliente se registra] -->|Envía datos| B(BackOffice: Módulo Cuentas)
    B --> C{Revisión de Cuenta}
    C -->|Vincula Líneas de Crédito| D[Cuenta Activa]
    
    %% Flujo de Recarga
    D -->|Solicita Recarga| E(App Móvil: Solicitud enviada)
    E --> F[BackOffice: Módulo Solicitudes]
    F -->|Notifica| G(Perfil Contador)
    G -->|Revisa y Pre-aprueba| H(Perfil Gerente General)
    H -->|Aprobación Final| I[Saldo Actualizado en BackOffice]
    I -->|Refleja en App| J[App Móvil: Cliente ve nuevo saldo]
```
