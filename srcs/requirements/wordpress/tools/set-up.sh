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

else
    echo "WORDPRESS: WordPress already configured"
fi

exec php-fpm8.2 -F


# #!/usr/bin/bash
# set -e
# 
# WP_PATH="/var/www/html"
# 
# # Read secrets
# DB_PASS=$(cat /run/secrets/db_password)
# WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
# WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
# 
# echo "WORDPRESS: Waiting for MariaDB..."
# until mariadb-admin ping \
#     -h mariadb \
#     -u"$DB_USER" \
#     -p"$DB_USER_PWD" \
#     --silent; do
#     sleep 2
# done
# echo "WORDPRESS: MariaDB is ready!"
# 
# mkdir -p $WP_PATH
# cd $WP_PATH
# 
# # Install WordPress only if not installed
# if ! wp core is-installed --path="$WP_PATH" --allow-root; then
#     echo "WORDPRESS: Downloading WordPress..."
#     wp core download --path="$WP_PATH" --allow-root
# 
#     echo "WORDPRESS: Creating wp-config.php..."
#     wp config create \
#         --path="$WP_PATH" \
#         --dbname="$DB_NAME" \
#         --dbuser="$DB_USER" \
#         --dbpass="$DB_USER_PWD" \
#         --dbhost="mariadb" \
# 
#     echo "WORDPRESS: Installing WordPress..."
#     wp core install \
#         --path="$WP_PATH" \
#         --url="https://${LOGIN}.42.fr" \
#         --title="$WP_TITLE" \
#         --admin_user="$WP_ADMIN_NAME" \
#         --admin_password="$WP_ADMIN_PASSWORD" \
#         --admin_email="$WP_ADMIN_EMAIL" \
#         --skip-email \
#         --allow-root
# 
#     echo "WORDPRESS: Creating regular user..."
#     wp user create \
#         "$WORDPRESS_USER" \
#         "$WORDPRESS_USER_EMAIL" \
#         --role=author \
#         --user_pass="$WORDPRESS_USER_PASSWORD" \
#         --path="$WP_PATH" \
#         --allow-root
# 
#     echo "WORDPRESS: Setting permissions..."
#     chown -R www-data:www-data $WP_PATH
# fi
# 
# echo "WORDPRESS: Starting PHP-FPM..."
# exec php-fpm8.2 -F
