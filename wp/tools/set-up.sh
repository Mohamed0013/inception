#!/bin/bash
set -e

echo "Waiting for MariaDB..."

# Wait until MariaDB is reachable
until mysqladmin ping -h mariadb -u"$DB_USER" -p"$DB_USER_PWD" --silent; do
    sleep 1
done

echo "MariaDB is up."

# Install WordPress only if not already installed
if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."

    wp core download --allow-root

    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_USER_PWD" \
        --dbhost="mariadb" \
        --allow-root

    wp core install \
        --url="https://${LOGIN}.42.fr" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_NAME" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create \
        "$WORDPRESS_USER" \
        "$WORDPRESS_USER_EMAIL" \
        --role=author \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --allow-root

    wp theme activate twentytwentyfour --allow-root

    chown -R www-data:www-data /var/www/html
else
    echo "WordPress already installed."
fi

echo "Starting PHP-FPM..."
mkdir -p /run/php

# Replace shell with php-fpm (PID 1)
exec php-fpm7.4 -F
