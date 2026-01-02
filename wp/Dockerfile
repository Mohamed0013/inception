FROM debian:bullseye

# Install required packages
RUN apt update && apt install -y \
    curl \
    php7.4-fpm \
    php7.4-mysql \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on TCP port 9000 instead of Unix socket
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Copy startup script
COPY ./tools/set-up.sh /set-up.sh
RUN chmod +x /set-up.sh

# WordPress directory
WORKDIR /var/www/html

# PHP-FPM port
EXPOSE 9000

# Start container
CMD ["/set-up.sh"]
