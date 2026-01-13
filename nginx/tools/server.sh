#!/usr/bin/bash

# Check if environment variables are set
if [ -z "$SSL_CERTIFICATE" ] || [ -z "$SSL_CERTIFICATE_KEY" ] || [ -z "$LOGIN" ]; then
    echo "Error: Required environment variables are not set"
    echo "Please ensure SSL_CERTIFICATE, SSL_CERTIFICATE_KEY, and LOGIN are set in .env file"
    exit 1
fi

# Generate a self-signed SSL certificate if it doesn't exist
if [ ! -f "$SSL_CERTIFICATE" ] || [ ! -f "$SSL_CERTIFICATE_KEY" ]; then
    echo "Generating SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$SSL_CERTIFICATE_KEY" -out "$SSL_CERTIFICATE" \
    -subj "/C=MA/L=Benguerir/O=UM6P/OU=1337/CN=localhost"

    #nodes : don’t encrypt the private key with a passphrase.
    #keyout : where to save the key of that ssl certificate.
    #out : there to save the certificate itself.
    #Country Locality Organization Organizational Unit Common Name
fi

chmod 600 /etc/ssl/private/nginx.key
chmod 644 /etc/ssl/certs/nginx.crt

# Replace environment variables in nginx config
echo "Configuring nginx..."
envsubst '${SSL_CERTIFICATE} ${SSL_CERTIFICATE_KEY} ${LOGIN}' \
< /etc/nginx/sites-enabled/default \
> /etc/nginx/sites-enabled/default.tmp
mv /etc/nginx/sites-enabled/default.tmp /etc/nginx/sites-enabled/default

# Ensure the proper ownership for the web directory
chown -R www-data:www-data /var/www/html/
# www-data is the default user that nginx runs with and we need this user to won everything in the web directory

# Start NGINX
echo "Starting nginx..."
nginx -g "daemon off;"
#when you run nginx simply nginx forks into a background daemon and docker thinks the pid1 is finished and the container die.
# (it runs by default with daemon on) -g allows you to pass global directives to Nginx from the command line.