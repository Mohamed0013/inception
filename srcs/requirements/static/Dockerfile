FROM debian:bookworm

RUN apt update && apt install --no-install-recommends -y nginx

RUN rm /etc/nginx/sites-enabled/default

COPY ./conf/default /etc/nginx/sites-enabled/default
COPY ./html /var/www/static

RUN chown -R www-data:www-data /var/www/static

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]