# User Documentation - Inception

## Overview

This project provides a complete web infrastructure with:
- **NGINX** - A secure web server with HTTPS (TLS v1.3)
- **WordPress** - A content management system for building your website
- **MariaDB** - A database server that stores all your website data

All services run in isolated Docker containers and communicate securely with each other.

---

## Getting Started

### Starting the Project

To start the infrastructure:

```bash
make
```

This command will:
1. Create necessary data directories
2. Build Docker images
3. Start all services (WordPress, NGINX, MariaDB)

To start an already-built project in the background:

```bash
make start
```

### Stopping the Project

To stop all services:

```bash
make stop
```

To completely remove containers and clean up (⚠️ data persists):

```bash
make clean
```

To remove everything including volumes (⚠️ deletes all data):

```bash
make fclean
```

---

## Accessing Your Website

### Opening the Website

1. Open your web browser
2. Visit: `https://mohdahma.42.fr` (or your configured domain)
3. ⚠️ **Browser Warning**: A security warning will appear because we use a self-signed certificate. This is normal and expected. Click "Advanced" and proceed.

### Accessing the WordPress Admin Panel

1. After the site loads, go to: `https://mohdahma.42.fr/wp-admin`
2. Log in with your admin credentials

---

## Credentials Management

### Where Credentials Are Stored

Sensitive passwords are stored in files inside the `secrets/` directory:

- **Database Password**: `secrets/db_password.txt`
- **WordPress Admin Password**: `secrets/wp_admin_password.txt`
- **WordPress User Password**: `secrets/wp_user_password.txt`

⚠️ **Important**: Never share these files or commit them to version control.

### Current Credentials

Your credentials are:
- **DB Password**: Check `secrets/db_password.txt`
- **WordPress Admin Password**: Check `secrets/wp_admin_password.txt`
- **WordPress User Password**: Check `secrets/wp_user_password.txt`

### Changing Credentials

To change credentials, you must:
1. Stop the project: `make stop`
2. Edit the password files in `secrets/`
3. Delete the existing data: `make fclean`
4. Restart: `make`

---

## Checking Service Status

### Verify Services Are Running

Check if all containers are active:

```bash
docker ps
#Or
ps #(using Makefile commands)
```

You should see three containers:
- `wordpress` - Running PHP-FPM
- `nginx` - Running the web server
- `mariadb` - Running the database

### View Service Logs

To see what's happening in the services:

```bash
# View all logs
using Makfile commands  =>  logs
using docker compose    =>  docker compose -f ./srcs/docker-compose.yml logs

# View specific service logs
using Makefile commands =>  logs-service_name

using docker compose :
docker compose -f ./srcs/docker-compose.yml logs wordpress
docker compose -f ./srcs/docker-compose.yml logs nginx
docker compose -f ./srcs/docker-compose.yml logs mariadb

# Follow logs in real-time
docker compose -f ./srcs/docker-compose.yml logs -f
```

### Check Service Health

- **NGINX**: Should be accessible at `https://mohdahma.42.fr`
- **WordPress**: Should load the WordPress dashboard
- **MariaDB**: Verify WordPress can connect (no errors in logs)

---

## Troubleshooting

### Website Not Loading

1. Check if services are running: `docker ps`
2. View logs: `docker compose -f ./srcs/docker-compose.yml logs`
3. Ensure the domain `mohdahma.42.fr` is in your `/etc/hosts` file:
   ```
   127.0.0.1 mohdahma.42.fr
   ```

### WordPress Setup Failed

1. Check WordPress logs: `docker compose -f ./srcs/docker-compose.yml logs wordpress`
2. Verify MariaDB is running: `docker compose -f ./srcs/docker-compose.yml logs mariadb`
3. If stuck, restart everything: `make fclean && make`

### SSL Certificate Warning

This is normal with self-signed certificates. The connection is still secure (TLS v1.3).

---

## Data Location

Your website files and database are stored locally:

- **WordPress Files**: `/home/mohdahma/data/wordpress/`
- **Database Files**: `/home/mohdahma/data/db/`

These locations persist even after stopping containers.

---

## Support

For issues or questions, check the [Developer Documentation](DEV_DOC.md) or review the [Project README](README.md).