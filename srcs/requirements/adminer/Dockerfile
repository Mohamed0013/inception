FROM debian:bookworm

RUN apt update && apt install --no-install-recommends -y \
    php8.2-cli \
    php8.2-mysqli \
    curl

RUN mkdir -p /var/www/html/adminer

WORKDIR /var/www/html/adminer

RUN curl -o adminer.php https://www.adminer.org/latest.php

COPY ./conf/index.php /var/www/html/adminer/index.php

EXPOSE 9001

CMD ["php", "-S", "0.0.0.0:9001"]
