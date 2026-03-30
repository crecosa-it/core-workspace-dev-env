CREATE DATABASE IF NOT EXISTS ctpagabd;
CREATE DATABASE IF NOT EXISTS ctpagabd_logs;
CREATE DATABASE IF NOT EXISTS ctpagabd_bridge_aut;
CREATE DATABASE IF NOT EXISTS SMCF_COBRO;
CREATE DATABASE IF NOT EXISTS simicrofin_crecosa;
CREATE DATABASE IF NOT EXISTS guaranteedb;
CREATE DATABASE IF NOT EXISTS dbreportes;
CREATE DATABASE IF NOT EXISTS filestoragedb;
CREATE DATABASE IF NOT EXISTS rptdb;

-- Optional: Grant all privileges to the admin user on all these databases
-- This ensures the 'admin' user created by docker-compose can access them.
GRANT ALL PRIVILEGES ON ctpagabd.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON ctpagabd_logs.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON ctpagabd_bridge_aut.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON SMCF_COBRO.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON simicrofin_crecosa.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON guaranteedb.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON dbreportes.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON filestoragedb.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON rptdb.* TO 'admin'@'%';

FLUSH PRIVILEGES;
