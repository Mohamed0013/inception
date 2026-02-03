FROM debian:bookworm

RUN apt update && apt install --no-install-recommends -y \
    php8.2-fpm \
    php8.2-mysqli \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html/adminer

WORKDIR /var/www/html/adminer

# Download Adminer directly
RUN curl -o adminer.php https://www.adminer.org/latest.php

EXPOSE 9001

CMD ["php", "-S", "0.0.0.0:9001"]
