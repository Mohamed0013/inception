#!/bin/bash
set -e

DB_PASS=$(cat /run/secrets/db_password)

echo "WORDPRESS: Waiting for MariaDB..."
until mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" --silent; do
    sleep 1
done
echo "WORDPRESS: MariaDB is ready!"

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "WORDPRESS: Setting up WordPress..."

    wp core download --allow-root || true

    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --allow-root

    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    chown -R www-data:www-data /var/www/html

else
    echo "WORDPRESS: WordPress already configured"
fi

exec php-fpm8.2 -F
