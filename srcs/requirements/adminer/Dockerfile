FROM debian:bookworm

RUN apt update && apt install --no-install-recommends -y \
    php8.2-fpm \
    php8.2-mysqli \
    curl

RUN mkdir -p /var/www/html/adminer

WORKDIR /var/www/html/adminer

RUN curl -o adminer.php https://www.adminer.org/latest.php

RUN sed -i 's|^listen = .*|listen = 9001|' /etc/php/8.2/fpm/pool.d/www.conf

COPY ./conf/index.php /var/www/html/adminer/index.php

RUN chown -R www-data:www-data /var/www/html/adminer

EXPOSE 9001

CMD ["php-fpm8.2", "-F"]