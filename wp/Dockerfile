FROM debian:bookworm

RUN apt update && apt install -y curl php8.2-fpm php8.2-mysql

# downloading the WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# configure PHP-FPM to listen on port 9000
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
#Without -i, sed would only show the new content without saving it.
COPY ./tools/set-up.sh .
RUN chmod +x set-up.sh

# Set the working directory
WORKDIR /var/www/html/

# Expose port 9000 for PHP-FPM
EXPOSE 9000

CMD ["/set-up.sh"]
