import json
import os

# Load TEST data
test_file = r'C:\Users\devuser\.gemini\antigravity\brain\c465b8c3-2527-4a2f-b854-530b8bcc37ff\.system_generated\steps\184\output.txt'
with open(test_file, 'r') as f:
    test_data = json.load(f)['result']

# Load DEV Permisos
dev_perms_file = r'C:\Users\devuser\.gemini\antigravity\brain\c465b8c3-2527-4a2f-b854-530b8bcc37ff\.system_generated\steps\187\output.txt'
with open(dev_perms_file, 'r') as f:
    dev_permisos = json.load(f)['result']

# DEV Bridges (from step 188)
dev_bridges = [
    {"ID": 16, "ID_ROL": 1, "ID_OBJETO": "BACK_OFFICE"},
    {"ID": 10, "ID_ROL": 1, "ID_OBJETO": "CL_NAT"},
    {"ID": 17, "ID_ROL": 1, "ID_OBJETO": "CRE_API"},
    {"ID": 21, "ID_ROL": 2, "ID_OBJETO": "CRE_API"},
    {"ID": 7, "ID_ROL": 4, "ID_OBJETO": "AF_AFIL"},
    {"ID": 1, "ID_ROL": 4, "ID_OBJETO": "CL_NAT"},
    {"ID": 22, "ID_ROL": 4, "ID_OBJETO": "CRE_API"},
    {"ID": 4, "ID_ROL": 4, "ID_OBJETO": "CR_SOL"},
    {"ID": 12, "ID_ROL": 8, "ID_OBJETO": "AF_AFIL"},
    {"ID": 23, "ID_ROL": 8, "ID_OBJETO": "CRE_API"},
    {"ID": 11, "ID_ROL": 8, "ID_OBJETO": "CR_LOC"},
    {"ID": 8, "ID_ROL": 9, "ID_OBJETO": "AF_AFIL"},
    {"ID": 2, "ID_ROL": 9, "ID_OBJETO": "CL_NAT"},
    {"ID": 24, "ID_ROL": 9, "ID_OBJETO": "CRE_API"},
    {"ID": 5, "ID_ROL": 9, "ID_OBJETO": "CR_SOL"},
    {"ID": 16, "ID_ROL": 10, "ID_OBJETO": "AF_AFIL"}, # Fixing some mapping based on prev output if needed, but using tool output 188
    {"ID": 9, "ID_ROL": 10, "ID_OBJETO": "AF_AFIL"},
    {"ID": 3, "ID_ROL": 10, "ID_OBJETO": "CL_NAT"},
    {"ID": 18, "ID_ROL": 10, "ID_OBJETO": "CRE_API"},
    {"ID": 6, "ID_ROL": 10, "ID_OBJETO": "CR_SOL"},
    {"ID": 15, "ID_ROL": 14, "ID_OBJETO": "AF_AFIL"},
    {"ID": 13, "ID_ROL": 14, "ID_OBJETO": "CL_NAT"},
    {"ID": 14, "ID_ROL": 14, "ID_OBJETO": "CR_SOL"}
]

# Create maps for faster lookup
dev_perm_map = {(p['RECURSO'], p['ACCION']): p['ID'] for p in dev_permisos}
dev_bridge_map = {(b['ID_ROL'], b['ID_OBJETO']): b['ID'] for b in dev_bridges}

inserts = []
for item in test_data:
    perm_key = (item['RECURSO'], item['ACCION'])
    bridge_key = (item['ID_ROL'], item['ID_OBJETO'])
    
    dev_perm_id = dev_perm_map.get(perm_key)
    dev_role_id = dev_bridge_map.get(bridge_key)
    
    if dev_perm_id and dev_role_id:
        inserts.append(f"({dev_role_id}, {dev_perm_id})")

if inserts:
    sql = "DELETE FROM SG_ROLES_PERMISOS;\n"
    sql += "INSERT INTO SG_ROLES_PERMISOS (ID_ROLE, ID_PERMISO) VALUES\n"
    sql += ",\n".join(inserts) + ";"
    output_path = r'd:\Proyectos\Credit_Core_Work_Space\sync_permissions.sql'
    with open(output_path, 'w') as f:
        f.write(sql)
    print(f"Generated {len(inserts)} inserts in {output_path}")
else:
    print("No matches found to sync.")
