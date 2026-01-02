#!/bin/bash

set -e

# Initialize database only if it does not already exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB database..."

	mysqld --user=mysql --bootstrap <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PWD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	echo "MariaDB initialization complete."
fi

# Start MariaDB in foreground as PID 1
exec mysqld --user=mysql