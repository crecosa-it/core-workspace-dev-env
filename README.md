# Credit Core Workspace - Development Environment (core-workspace-dev-env)

Este repositorio contiene las configuraciones, scripts, documentación e infraestructura (como Docker Compose) globales necesarias para levantar y administrar el entorno de desarrollo local para el proyecto **Credit Core**.

> **Nota:** Este repositorio de entorno ignora los proyectos reales de código (APIs y UIs). Cada microservicio (API) y componente de Frontend (UI) se gestiona en su propio repositorio individual.

## 📂 ¿Qué contiene este repositorio?

- **Configuración de Docker (`docker-compose.yml`, `init-db.sql`):** Para levantar fácilmente las bases de datos y servicios de infraestructura requeridos de forma local.
- **Scripts de inicialización y sincronización:** Scripts en Python (`process_sync.py`), PowerShell (`run_all.ps1`) y SQL (`sync_permissions.sql`) para automatizar el alta de la base de datos o correr servicios.
- **Workspace de IDE:** Archivos de configuración general (como `manage-credits.code-workspace` o la carpeta `.vscode/`) para integrar todos los sub-repositorios en un gran proyecto.
- **Reglas del agente (`.agent/`):** Habilidades o configuraciones personalizadas para los asistentes de inteligencia artificial (`db-tools`, `skills`).
- **Documentación (`.docs/`):** Documentos de arquitectura y despliegue del proyecto en general.
- **Herramientas de despliegue (`.tools/`):** Scripts y configuraciones para automatizar despliegues o validaciones de ambiente.

## 🚀 Cómo empezar (Local Setup)

1. **Clona este repositorio base:**
   Asegúrate de clonar esto en el que será el directorio raíz de todos tus proyectos de Credit Core.
   ```bash
   git clone git@github.com:crecosa-it/core-workspace-dev-env.git Credit_Core_Work_Space
   cd Credit_Core_Work_Space
   ```

2. **Clona los repositorios de las APIs y UIs (dentro de este mismo directorio):**
   Las APIs (ej. `api-credit`, `api-backoffice`) y las UIs (ej. `ui-backoffice`, `ui-legacy`) deberán ser clonadas aquí adentro. Estas carpetas ya se ignoran vía `.gitignore`.

3. **Inicia la infraestructura:**
   Dependiendo de lo que necesites probar, puedes levantar los servicios requeridos (bases de datos, message brokers, etc.):
   ```bash
   docker-compose up -d
   ```

## 📝 Reglas de uso

- **No comprometer código de las aplicaciones aquí.** Este repo es estrictamente para la configuración del *Workspace*, scripts y orquestación.
- Cualquier script de automatización o configuración de entorno local nuevo debería agregarse aquí para el uso de todo el equipo de ingeniería.
