#!/usr/bin/bash

# Start MariaDB
service mariadb start

# Wait for MariaDB to start
sleep 5

# Create database and user if they do not exist
mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PWD';"  #in mysql and mariadb user is indentified by username@host so we did username@anyhost
mysql -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';"   #db_user could do anything in the database with all its tables

# Stop MariaDB
service mariadb stop

# Start the MariaDB daemon
exec mysqld
