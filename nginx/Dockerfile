FROM debian:bullseye

# Update the package list, upgrade installed packages, and install NGINX and OpenSSL
RUN apt update -y && apt install --no-install-recommends -y nginx openssl gettext

# Create directories for certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Copy the NGINX site configuration file and the script
COPY ./conf/default /etc/nginx/sites-enabled/default
COPY ./tools/server.sh .
# Ensure the script is executable
RUN chmod +x server.sh

# Expose port 443
EXPOSE 443

# Start NGINX using the Bash script
CMD ["bash", "server.sh"]