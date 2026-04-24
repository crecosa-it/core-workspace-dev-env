---
name: db-query
description: Safe procedure to query and analyze Credit Core MySQL databases. Defines available databases, their purpose, and usage rules.
---

# Skill: Database Query (Credit Core)

## How to Use the Database MCP (Critical)

The database MCP is **ALREADY CONFIGURED** and available as a direct tool.

### Correct Tool: `mcp_database_sql_query`

```
CORRECT:   mcp_database_sql_query(sql: "SELECT * FROM table LIMIT 5")
INCORRECT: list_resources(ServerName: "database")
INCORRECT: read_resource(ServerName: "database", Uri: "...")
```

> `list_resources` and `read_resource` do NOT work with this MCP. The server exposes **tools**, not resources. The mapped tool is `mcp_database_sql_query`.

### Immediate Usage Examples

```python
mcp_database_sql_query(sql="SELECT * FROM ctpagabd.SG_USUARIOS LIMIT 5")
mcp_database_sql_query(sql="DESCRIBE ctpagabd.CR_SOLICITUD_CREDITO")
mcp_database_sql_query(sql="SHOW TABLES")
```

### Other Available MCP Tools
- `mcp_database_get_database_info` - General server and database info
- `mcp_database_check_permissions` - Check available permissions (DDL, DROP, etc.)
- `mcp_database_get_operation_logs` - View operation logs
- `mcp_database_get_ddl_sql_logs` - View DDL logs

---

## Fallback Tool (When MCP fails)

If the database MCP returns connection errors, use the local Python tool:

```powershell
# List all databases in the server
python d:\Proyectos\Credit_Core_Work_Space\.agent\scripts\db-tools\db_explorer.py --action list_dbs

# Query specific table (e.g., filestoragedb.File)
python d:\Proyectos\Credit_Core_Work_Space\.agent\scripts\db-tools\db_explorer.py --action query --db filestoragedb --sql "SELECT * FROM File LIMIT 5"
```

---

## Available Databases

| Database Name          | Purpose                                        | Port |
|------------------------|------------------------------------------------|------|
| `ctpagabd`             | Main Credit Core / CTPaga database             | 9699 |
| `SMCF_COBRO`           | Collections and debt management                | 9699 |
| `simicrofin_crecosa`   | Legacy Crecosa microfinance system             | 9699 |
| `guaranteedb`          | Guarantee management                           | 9699 |
| `dbreportes`           | Reporting and dashboards                       | 9699 |
| `filestoragedb`        | File metadata and Cloudinary tracking          | 9699 |

- **Host**: `192.168.1.85`
- **Port**: `9699`
- **User**: `admin`
- **Engine**: MySQL / MariaDB

> To query a database other than the default `ctpagabd`, prefix the table name: `SELECT * FROM SMCF_COBRO.SG_USUARIO LIMIT 5`

---

## Query Procedure

### Step 1: Explore the schema before querying
```sql
SHOW TABLES;
DESCRIBE table_name;
SHOW COLUMNS FROM table_name;
```

### Step 2: Read-only queries by default
- Only execute `SELECT` unless the user explicitly confirms otherwise.
- Never run `DELETE`, `UPDATE`, or `DROP` on production without explicit confirmation.

### Step 3: Limit results
```sql
SELECT * FROM table LIMIT 10;
```

---

## Key Known Tables (ctpagabd)

| Table | Description |
|-------|-------------|
| `CR_SOLICITUD_CREDITO` | Credit requests |
| `SG_USUARIOS` | System users (ID_USUARIO string, ID_OFICINA, ID_ROL) |
| `SG_ASIGNAR_OFICINA` | Office assignments per user (ID_OFICINA, ID_USUARIO, ACTIVO) |
| `CF_OFICINAS` | Office catalog |
| `CLI_PERFIL` | Client profiles |
| `CR_ESTADO_ACTUAL_SOLICITUD` | Current state of credit requests |

---

## Security Rules
- Never expose passwords (`PASS_USER`, `CLAVE`, `REFRESHWT`) or tokens in results.
- Never modify production data without explicit user confirmation.
- Always confirm the database name before running critical queries.
