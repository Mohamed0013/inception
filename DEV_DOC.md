# Developer Documentation - Inception

## Project Overview

This is a Docker Compose-based infrastructure project containing three main services:
- **WordPress** (PHP-FPM) on port 9000
- **NGINX** (Reverse Proxy) on port 443
- **MariaDB** (Database) on port 3306

Services communicate through a custom Docker network and persist data using Docker volumes.

---

## Prerequisites

Before you begin, ensure you have installed:

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **Linux/macOS** or **WSL2 on Windows**
- **Basic knowledge of Docker and networking**

Verify installation:

```bash
docker --version
docker compose --version
```

---

## Project Structure

```
.
├── Makefile                          # Build and run commands
├── README.md                         # Project overview
├── Assets/                           # Project assets
├── secrets/                          # Sensitive data (passwords)
│   ├── db_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env.example                  # Environment variables template
    ├── docker-compose.yml            # Docker Compose orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── 50-server.cnf     # MariaDB configuration
        │   └── tools/
        │       └── create_db.sh      # Database initialization script
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── default           # NGINX site configuration
        │   └── tools/
        │       └── server.sh         # SSL setup and NGINX start script
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── set-up.sh         # WordPress setup script
```

---

## Setup from Scratch

### Step 1: Clone/Prepare the Repository

```bash
cd /path/to/project
```

### Step 2: Create Environment Configuration

Copy the example environment file:

```bash
cp srcs/.env.example srcs/.env
```

Edit `srcs/.env` and configure your settings:

```bash
nano srcs/.env
```

**Key variables to configure:**

```env
# Server/Domain Settings
LOGIN=your_login_here
SSL_CERTIFICATE=/etc/ssl/certs/nginx.crt
SSL_CERTIFICATE_KEY=/etc/ssl/private/nginx.key

# Database Settings
DB_HOST=mariadb
DB_NAME=wordpress
DB_USER=your_db_user
DB_PASS=your_db_password

# WordPress Settings
WP_URL=https://your_domain_here
WP_TITLE=Your Site Title
WP_ADMIN=admin_user
WP_ADMIN_PASSWORD=secure_password
WP_ADMIN_EMAIL=admin@example.com
```

### Step 3: Create/Verify Secret Files

Ensure password files exist in `secrets/` directory:

```bash
mkdir -p secrets

# Create password files (one password per line)
echo "your_db_password" > secrets/db_password.txt
echo "your_wp_admin_password" > secrets/wp_admin_password.txt
echo "your_wp_user_password" > secrets/wp_user_password.txt
```

**Important**: Never commit these files to version control. Add to `.gitignore`:

```
secrets/
.env
/data/
```

### Step 4: Update /etc/hosts (for local development)

Add your domain to your hosts file:

```bash
sudo nano /etc/hosts
```

Add the line:

```
127.0.0.1 your_login.42.fr localhost
```

### Step 5: Create Data Directories

The [Makefile](Makefile) does this automatically, but you can create manually:

```bash
mkdir -p /home/mohdahma/data/db
mkdir -p /home/mohdahma/data/wordpress
```

---

## Building and Running

### Full Build (Recommended)

Build images and start all services:

```bash
make
```

This command executes:
```bash
mkdir -p /home/mohdahma/data/db
mkdir -p /home/mohdahma/data/wordpress
docker compose -f ./srcs/docker-compose.yml up --build
```

### Start Existing Services

If images are already built:

```bash
make start
```

Equivalent to:
```bash
docker compose -f ./srcs/docker-compose.yml up -d
```

### Stop Services

Stop all running containers:

```bash
make stop
```

Equivalent to:
```bash
docker compose -f ./srcs/docker-compose.yml down
```

---

## Docker Compose Management

### View Running Containers

```bash
docker ps
```

Expected output should show:
- `wordpress` container
- `nginx` container
- `mariadb` container

### View Container Logs

```bash
# All services
docker compose -f ./srcs/docker-compose.yml logs

# Specific service
docker compose -f ./srcs/docker-compose.yml logs wordpress
docker compose -f ./srcs/docker-compose.yml logs nginx
docker compose -f ./srcs/docker-compose.yml logs mariadb

# Follow logs in real-time
docker compose -f ./srcs/docker-compose.yml logs -f wordpress
```

### Execute Commands in Running Container

```bash
# Access WordPress container shell
docker exec -it wordpress /bin/bash

# Access MariaDB container shell
docker exec -it mariadb /bin/bash

# Access NGINX container shell
docker exec -it nginx /bin/bash
```

### View Container Details

```bash
# Inspect container configuration
docker inspect wordpress

# View container resource usage
docker stats
```

---

## Data Persistence

### Volume Configuration

Volumes are defined in [srcs/docker-compose.yml](srcs/docker-compose.yml):

```yaml
volumes:
  db:
    driver_opts:
      type: none
      o: bind
      device: /home/mohdahma/data/db/

  wordpress:
    driver_opts:
      type: none
      o: bind
      device: /home/mohdahma/data/wordpress/
```

These are **bind mounts** pointing to host directories.

### Data Locations

- **WordPress Files**: `/home/mohdahma/data/wordpress/`
  - Contains all WordPress core files, themes, plugins
  - Shared between WordPress and NGINX containers

- **MariaDB Files**: `/home/mohdahma/data/db/`
  - Contains all database files
  - Persists across container restarts

### Accessing Data Directly

```bash
# List WordPress files
ls -la /home/mohdahma/data/wordpress/

# List database files
ls -la /home/mohdahma/data/db/

# View WordPress database files
sudo ls /home/mohdahma/data/db/mysql/wordpress/
```

### Data Persistence Behavior

| Action | Data Persistence |
|--------|------------------|
| `make stop` | ✅ Data persists |
| `make clean` | ✅ Data persists |
| `make fclean` | ❌ Data **deleted** |
| Container crash | ✅ Data persists |
| Image rebuild | ✅ Data persists |

---

## Service Details

### WordPress Container

**File**: [srcs/requirements/wordpress/Dockerfile](srcs/requirements/wordpress/Dockerfile)

- **Base Image**: Debian Bookworm
- **Key Components**: PHP 8.2-FPM, WordPress CLI
- **Port**: 9000 (internal, not exposed)
- **Startup Script**: [srcs/requirements/wordpress/tools/set-up.sh](srcs/requirements/wordpress/tools/set-up.sh)

**What the startup script does:**
1. Waits for MariaDB to be ready
2. Downloads WordPress core
3. Creates `wp-config.php` with database credentials
4. Runs WordPress installation
5. Sets proper file permissions
6. Starts PHP-FPM

### NGINX Container

**File**: [srcs/requirements/nginx/Dockerfile](srcs/requirements/nginx/Dockerfile)

- **Base Image**: Debian Bookworm
- **Key Components**: NGINX, OpenSSL
- **Port**: 443 (HTTPS only)
- **Configuration**: [srcs/requirements/nginx/conf/default](srcs/requirements/nginx/conf/default)
- **Startup Script**: [srcs/requirements/nginx/tools/server.sh](srcs/requirements/nginx/tools/server.sh)

**What the startup script does:**
1. Validates required environment variables
2. Generates self-signed SSL certificates (if missing)
3. Substitutes environment variables in NGINX config
4. Sets proper file permissions
5. Starts NGINX in foreground

**Key Configuration Features:**
- TLS v1.3 only
- Proxy to WordPress via `fastcgi_pass wordpress:9000`
- Serves from `/var/www/html`

### MariaDB Container

**File**: [srcs/requirements/mariadb/Dockerfile](srcs/requirements/mariadb/Dockerfile)

- **Base Image**: Debian Bookworm
- **Key Components**: MariaDB server
- **Port**: 3306 (not exposed, only accessible via Docker network)
- **Configuration**: [srcs/requirements/mariadb/conf/50-server.cnf](srcs/requirements/mariadb/conf/50-server.cnf)
- **Startup Script**: [srcs/requirements/mariadb/tools/create_db.sh](srcs/requirements/mariadb/tools/create_db.sh)

**What the startup script does:**
1. Reads database password from Docker secrets
2. Initializes MariaDB if not already initialized
3. Creates database and user
4. Sets proper permissions
5. Starts MariaDB in foreground

---

## Docker Network

All containers communicate through a custom bridge network named `inception`:

```bash
# View the network
docker network inspect inception

# All containers can reach each other by service name:
# - wordpress:9000 (from NGINX perspective)
# - mariadb:3306 (from WordPress perspective)
# - nginx:443 (from external perspective)
```

---

## Secrets Management

Passwords are stored securely using Docker Secrets:

```yaml
secrets:
  db_password:
    file: ../secrets/db_password.txt
  wp_admin_password:
    file: ../secrets/wp_admin_password.txt
  wp_user_password:
    file: ../secrets/wp_user_password.txt
```

**Inside containers**, secrets are mounted at:
- `/run/secrets/db_password`
- `/run/secrets/wp_admin_password`
- `/run/secrets/wp_user_password`

Example usage in scripts:
```bash
DB_PASS=$(cat /run/secrets/db_password)
```

---

## Troubleshooting

### Services Not Starting

**Check logs:**
```bash
docker compose -f ./srcs/docker-compose.yml logs
```

**Common issues:**

1. **MariaDB fails to initialize**
   - Ensure `/home/mohdahma/data/db/` is empty or valid
   - Check file permissions: `ls -la /home/mohdahma/data/db/`

2. **WordPress can't connect to MariaDB**
   - Verify MariaDB is running: `docker ps`
   - Check MariaDB logs: `docker compose -f ./srcs/docker-compose.yml logs mariadb`
   - Verify credentials in `.env` file

3. **NGINX certificate generation fails**
   - Check directory permissions: `/etc/ssl/certs/` and `/etc/ssl/private/`
   - View NGINX logs: `docker compose -f ./srcs/docker-compose.yml logs nginx`

### Accessing Container Internals

```bash
# Access MariaDB directly
docker exec -it mariadb mysql -u wordpress -p -D wordpress

# Check WordPress files
docker exec -it wordpress ls -la /var/www/html/

# Verify NGINX configuration
docker exec -it nginx nginx -t
```

### Resetting Everything

To start completely fresh:

```bash
make fclean
docker system prune -a -f --volumes
sudo rm -rf /home/mohdahma/data/wordpress /home/mohdahma/data/db
make
```

---

## Development Workflow

### Modifying WordPress Configuration

1. Edit files in `/home/mohdahma/data/wordpress/`
2. Changes are immediately reflected (shared volume)
3. No need to rebuild containers

### Modifying NGINX Configuration

1. Edit [srcs/requirements/nginx/conf/default](srcs/requirements/nginx/conf/default)
2. Rebuild: `docker compose -f ./srcs/docker-compose.yml up --build -d nginx`

### Modifying WordPress Startup Script

1. Edit [srcs/requirements/wordpress/tools/set-up.sh](srcs/requirements/wordpress/tools/set-up.sh)
2. Rebuild: `docker compose -f ./srcs/docker-compose.yml up --build -d wordpress`

### Changing Database

1. Stop services: `make stop`
2. Delete data: `sudo rm -rf /home/mohdahma/data/db/*`
3. Restart: `make start`

---

## Environment Variables Reference

See [srcs/.env.example](srcs/.env.example) for all available variables.

| Variable | Purpose | Example |
|----------|---------|---------|
| `LOGIN` | Username for domain | `mohdahma` |
| `DB_HOST` | Database hostname | `mariadb` |
| `DB_NAME` | Database name | `wordpress` |
| `DB_USER` | Database user | `wordpress` |
| `WP_URL` | WordPress site URL | `https://mohdahma.42.fr` |
| `WP_ADMIN` | Admin username | `admin_user` |
| `WP_ADMIN_EMAIL` | Admin email | `admin@42.fr` |

---

## Resources

- [Docker Documentation](https://docs.docker.com)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [MariaDB Documentation](https://mariadb.com/docs/)
- [OpenSSL Documentation](https://www.openssl.org/docs/)

---

## Contributing Notes

- All Dockerfiles use Debian Bookworm as base image
- Services run without root privileges where possible
- TLS v1.3 is enforced for security
- Self-signed certificates are intentionally used for development
- Volumes are bind mounts for easy local file access