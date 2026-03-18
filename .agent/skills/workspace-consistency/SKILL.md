---
description: Revisa y asegura la consistencia de la configuración del workspace (repositorios agregados en docs, config, vscode, tools), previniendo que servicios eliminados dejen basura o que servicios nuevos no se documenten. No debe filtrar secretos.
---

# Habilidad: Consistencia del Workspace (Workspace Consistency Check)

## Propósito
Analizar las carpetas principales del proyecto e identificar discrepancias entre los directorios reales (APIs, UIs) y las diferentes fuentes de verdad del `core-workspace-dev-env`. Se debe usar siempre que se elimine o introduzca una nueva API u UI.

## Reglas de Evaluación de Consistencia

Cuando se te pida evaluar la consistencia del workspace o aplicar este skill, debes seguir este riguroso checklist paso a paso:

### 1. Escaneo del Directorio Físico (`list_dir`)
*   Usa herramientas como `list_dir` en el directorio raíz (`Credit_Core_Work_Space`) para obtener la lista actual de repositorios o subcarpetas.
*   Identifica todas las carpetas con el prefijo `api-*` y `ui-*`.

### 2. Contraste de Fuentes (Cross-Check)
Verifica que TODAS las carpetas prefijadas y activas descubiertas arriba existan obligatoriamente en:
1.  **VScode Workspace:** `.vscode/tasks.json` y en la raíz `manage-credits.code-workspace` (bajo `folders` y `settings.git.scanRepositories`).
2.  **Documentación de Arquitectura:** `.docs/architecture.md` (En las listas de componentes Backend/Frontend).
3.  **Mapa de Entornos:** `.docs/environments.md` (Debe contar con su fila en la tabla y un puerto asignado si corre localmente).
4.  **Skills e Instrucciones del Agente:** `.agent/agent.md` (Listado estándar del proyecto).
5.  **Herramientas y Scripts:** `.tools/scripts/config/targets.json` (Debe estar mapeado para herramientas de CI/CD).
6.  **Orquestadores (Si aplica):** Buscar referencias en `docker-compose.yml`, `.gitignore` y  scripts de powershell (`.ps1`).

### 3. Criterios de Limpieza (Purga)
*   Si una carpeta fue eliminada o su lógica está obsoleta, DEBE ser purgada de **todos** los archivos listados en el paso 2. Utiliza `grep_search` masivo (con flags para buscar en archivos ocultos si es necesario) para asegurar su erradicación.

### 4. 🚨 Reglas de Seguridad y Secretos
*   **Nunca exfiltres, expongas o escribas** secretos reales (contraseñas, connection strings privados, keys de AWS, tokens JWT, IPs internas en texto plano no autorizado) en los reportes de salida de esta skill.
*   Si un script o docker compose contiene secretos duros (`password=...`), ignóralos en la evaluación de consistencia estructural. Focalízate solo en **nombres de servicios y arquitectura**.

## Output Esperado
Después de correr esta habilidad, el asistente debe emitir un reporte final listando:
1.  Las discrepancias encontradas (ej. "`api-x` está en la raíz pero falta en el README").
2.  Las acciones automáticas tomadas (archivos actualizados para reparar la inconsistencia).
3.  Advertencias sobre repositorios huérfanos.
