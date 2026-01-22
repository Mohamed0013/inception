#!/usr/bin/bash
set -e

DB_ROOT_PWD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize database directory if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysqld --initialize-insecure
fi

# Start MariaDB temporarily
mysqld --skip-networking &
pid="$!"

# Wait for server
until mysqladmin ping --silent; do
    sleep 1
done

# Create database and user
mysql -u root -p"$DB_ROOT_PWD" <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

# Stop temporary server
mysqladmin shutdown
wait "$pid"

# Start MariaDB in foreground (container main process)
exec mysqld
