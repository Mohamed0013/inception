#!/usr/bin/bash

# Wait for MariaDB to be ready
sleep 5

# Set up WordPress if not already installed
if [ ! -f "wp-config.php" ]; then
    # Download WordPress core
    wp core download --allow-root

    # Create wp-config.php
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_USER_PWD" \
        --dbhost="mariadb" \
        --allow-root

    # Install WordPress core
    wp core install \
        --url="https://${LOGIN}.42.fr" \
        --title="$WP_TITLE" \
        --admin_name="$WP_ADMIN_NAME" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    # Create secondary user
    wp user create \
        "$WORDPRESS_USER" \
        "$WORDPRESS_USER_EMAIL" \
        --role=author \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --allow-root

    wp theme activate twentytwentyfour --allow-root

    # Set correct permissions
    chown -R www-data:www-data /var/www/html
    # Not every file must be writable, but every file should at least be readable by www-data, and folders that PHP needs to write into must be owned/writable by www-data.
    # Using chown -R www-data:www-data /var/www/html is the easiest way in Docker to avoid permission issues.
fi

# if already installed
echo "WordPress is already installed"

# Execute CMD (php-fpm)
echo "Starting php-fpm..."
mkdir -p /run/php/
php-fpm8.2 -F
