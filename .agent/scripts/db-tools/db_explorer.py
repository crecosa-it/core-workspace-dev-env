import mysql.connector
import sys
import json
import argparse

def get_connection(database=None):
    config = {
        'user': 'admin',
        'password': 'It.crecosa01',
        'host': '192.168.1.85',
        'port': 9699,
        'database': database,
        'raise_on_warnings': True
    }
    return mysql.connector.connect(**config)

def list_databases():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SHOW DATABASES")
    dbs = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return dbs

def list_tables(database):
    conn = get_connection(database)
    cursor = conn.cursor()
    cursor.execute("SHOW TABLES")
    tables = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return tables

def query_sql(sql, database=None):
    conn = get_connection(database)
    cursor = conn.cursor(dictionary=True)
    cursor.execute(sql)
    
    if cursor.description: # If it's a SELECT
        result = cursor.fetchall()
    else:
        conn.commit()
        result = {"message": "Command executed successfully", "affected_rows": cursor.rowcount}
        
    cursor.close()
    conn.close()
    return result

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Universal DB Tool for Credit Core Server (192.168.1.85)')
    parser.add_argument('--action', choices=['list_dbs', 'list_tables', 'query'], required=True)
    parser.add_argument('--db', help='Database name')
    parser.add_argument('--sql', help='SQL Query to execute')
    
    args = parser.parse_args()
    
    try:
        if args.action == 'list_dbs':
            print(json.dumps(list_databases(), indent=2))
        elif args.action == 'list_tables':
            if not args.db:
                print("Error: --db is required for list_tables")
            else:
                print(json.dumps(list_tables(args.db), indent=2))
        elif args.action == 'query':
            if not args.sql:
                print("Error: --sql is required for query")
            else:
                print(json.dumps(query_sql(args.sql, args.db), default=str, indent=2))
    except Exception as e:
        print(json.dumps({"error": str(e)}))
