# User Documentation - Inception

## Overview

This project provides a complete web infrastructure with:
- **NGINX** - A secure web server with HTTPS (TLS v1.3)
- **WordPress** - A content management system for building your website
- **MariaDB** - A database server that stores all your website data
- **Redis** - A cache server to improve performance
- **Static Website** - Portfolio showcase

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
3. Start all services (WordPress, NGINX, MariaDB, Redis, Static Site)

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

### WordPress Admin Login

To access WordPress dashboard at `https://mohdahma.42.fr/wp-admin`:

- **Username**: Check `WP_ADMIN` value in `srcs/.env` (default: `superuser`)
- **Password**: Check `secrets/wp_admin_password.txt`

Example:
```
Username: superuser
Password: Wpadminpass19
```

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
```

You should see five containers:
- `wordpress` - Running PHP-FPM
- `nginx` - Running the web server
- `mariadb` - Running the database
- `redis` - Running cache server
- `static` - Running portfolio website

### View Service Logs

To see what's happening in the services:

```bash
# View all logs
docker compose -f ./srcs/docker-compose.yml logs

# View specific service logs
docker compose -f ./srcs/docker-compose.yml logs wordpress
docker compose -f ./srcs/docker-compose.yml logs nginx
docker compose -f ./srcs/docker-compose.yml logs mariadb
docker compose -f ./srcs/docker-compose.yml logs redis
docker compose -f ./srcs/docker-compose.yml logs static

# Follow logs in real-time
docker compose -f ./srcs/docker-compose.yml logs -f
```

Or use Makefile commands:
```bash
make logs              # View all logs
make logs-wp           # View WordPress logs
make logs-nginx        # View NGINX logs
make logs-db           # View MariaDB logs
```

### Check Service Health

- **NGINX**: Should be accessible at `https://mohdahma.42.fr`
- **WordPress**: Should load the WordPress dashboard
- **MariaDB**: Verify WordPress can connect (no errors in logs)
- **Redis**: Should start without errors
- **Static**: Portfolio accessible at `http://localhost:8080`

---

## Bonus Services

### Redis Cache

Redis improves WordPress performance by caching data.

- **Port**: 6379 (internal only, not exposed)
- **Purpose**: Cache management for faster page loads
- **Access**: Automatically integrated with WordPress

### Static Website Portfolio

Simple HTML/CSS showcase website.

- **Port**: 8080 (accessible externally)
- **URL**: `http://localhost:8080`
- **Purpose**: Portfolio and resume showcase
- **Features**: Responsive design, smooth navigation, project display

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