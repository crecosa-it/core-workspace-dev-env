# Módulo Billetera - Opciones del Menú

Este documento describe la funcionalidad y la razón de ser de cada una de las opciones disponibles en el menú del Módulo de Billetera (Mod. Billetera) en el BackOffice.

## 1. Wallet Overview (Resumen / Panel de Control)

* **¿Qué hace?:** Es la pantalla principal (Dashboard) del módulo. Muestra un resumen general y métricas clave del estado de las billeteras en tiempo real. Suele incluir gráficos de volumen de dinero transado, cantidad de usuarios activos, saldos totales retenidos en el sistema y alertas de anomalías.
* **Razón de ser:** Proporcionar a los administradores y gerentes una "fotografía" inmediata de la salud y el rendimiento del negocio de las billeteras digitales sin tener que buscar en reportes detallados. Permite la toma de decisiones rápidas.

## 2. Solicitudes

* **¿Qué hace?:** Es la bandeja de entrada para gestionar requerimientos de los usuarios o del sistema que necesitan aprobación manual. Esto puede incluir solicitudes de apertura de nuevas cuentas (KYC/validación de identidad), aumentos de límites de transaccionalidad, o solicitudes de retiros de fondos hacia cuentas bancarias externas que superan los umbrales automáticos.
* **Razón de ser:** Actuar como el filtro de seguridad y cumplimiento normativo (Compliance). Garantiza que ciertas acciones críticas no sucedan automáticamente, sino que pasen por la revisión de un operador humano del BackOffice para prevenir fraudes o lavado de dinero.

## 3. Transacciones

* **¿Qué hace?:** Un registro histórico y detallado de absolutamente todos los movimientos de dinero (entradas, salidas, transferencias entre usuarios, pagos a comercios, comisiones cobradas). Permite filtrar por fechas, montos, usuarios, estados (exitosa, fallida, pendiente) o IDs de transacción.
* **Razón de ser:** Es la herramienta principal para la conciliación contable y la resolución de disputas (Atención al Cliente). Si un usuario reporta que "un dinero no le llegó", el operador utiliza esta pantalla para rastrear el flujo exacto de esa transacción específica y ver dónde se detuvo.

## 4. Cuentas

* **¿Qué hace?:** El directorio maestro de todas las billeteras creadas. Al ingresar al perfil de una cuenta específica, el administrador puede ver sus saldos actuales, cambiar su estado (activar, bloquear, suspender), editar información del propietario o ajustar límites transaccionales individuales.
* **Razón de ser:** Es el módulo de gestión del ciclo de vida del cliente. Permite al equipo de soporte y operaciones administrar directamente el estado de los usuarios, bloqueando billeteras sospechosas o asistiendo a clientes legítimos con problemas en sus cuentas.
