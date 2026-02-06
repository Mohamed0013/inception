*This project has been created as part of the 42 curriculum by mohdahma.*

# Inception

## Description

**Inception** is a system administration and containerization project from the 42 curriculum.
The goal of this project is to design and deploy a complete web infrastructure using **Docker** and **Docker Compose**, following strict rules related to security, isolation, and service orchestration.

The infrastructure is composed of multiple services running in separate containers:
- **NGINX** as a reverse proxy with HTTPS (TLS v1.2 / v1.3)
- **WordPress** with PHP-FPM
- **MariaDB** as the database server

Each service runs in its own container, communicates through Docker networks, and stores persistent data using Docker volumes.

And in the bonus part we have :
- **Redis** a wordpress cache manager.
- **Static** a simple static website container.

---

## Project Goals

- Understand how Docker images and containers work
- Learn how to orchestrate multiple services with Docker Compose
- Secure a web application using TLS
- Apply best practices for container isolation, networking, and secrets management

---

## Instructions

### Prerequisites

- Docker
- Docker Compose
- A Linux system (VM recommended)

### Installation

Clone the repository:
```bash
git clone repo_link
cd inception (or the cloned folder name)
```

Configure environment variables:

```bash
cd srcs
cp .env.example .env
nano .env
```

⚠️ **Important**: Before editing `.env`, ensure these values match your system:

**Critical variables that must match your system:**

| Variable | Must Match                 | Example                           |
|----------|----------------------------|-----------------------------------|
| `LOGIN`  | Your actual login name     | `your_login` (your 42 username)   |
| `WP_URL` | Domain in `/etc/hosts`     | `https://your_login.42.fr`        |
| `DB_HOST`| Service name (leave as-is) | `mariadb`                         |
| `DB_NAME`| Service name (leave as-is) | `wordpress`                       |

**Before starting, ensure:**

1. Update `/etc/hosts` with your login:
   ```bash
   sudo nano /etc/hosts
   # Add this line (replace your_login with your actual username):
   127.0.0.1 your_login.42.fr
   ```

2. Make sure `.env` has matching values:
   ```env
   LOGIN=your_login
   WP_URL=https://your_login.42.fr
   ```

3. Create secret passwords:
   ```bash
   # Create and Edit these files with secure passwords
   nano ../secrets/db_password.txt
   nano ../secrets/wp_admin_password.txt
   nano ../secrets/wp_user_password.txt
   ```

**Build and Run:**

```bash
make
```

**Access the Website**

Open your browser and visit:

```
https://your_login.42.fr
```

⚠️ A browser warning is expected because a self-signed TLS certificate is used.

---

## Project Architecture

- Each service has its own Dockerfile
- Services communicate through a custom Docker network
- Persistent data is stored using Docker volumes
- Sensitive data is handled using Docker secrets

---

## Technical Choices and Explanations

### Docker and Docker Compose

Docker allows packaging an application with all its dependencies into a container.
Docker Compose orchestrates multiple containers, defining how they interact, share networks, volumes, and startup order.

### Virtual Machines vs Docker

| Virtual Machines        | Docker                   |
| ----------------------- | ------------------------ |
| Runs a full OS          | Shares host OS kernel    |
| Heavy and slow to start | Lightweight and fast     |
| High resource usage     | Efficient resource usage |
| Strong isolation        | Process-level isolation  |

**Why Docker?**
Docker provides faster deployment, better resource efficiency, and easier compared to virtual machines.

### Environment Variables vs Docker Secrets

| Environment Variables       | Docker Secrets         |
| --------------------------- | ---------------------- |
| Visible via inspect         | Stored securely        |
| Easy to leak                | Limited access         |
| Good for non-sensitive data | Designed for passwords |

**Why secrets?**
Passwords and sensitive data (DB password, admin password) must not be exposed inside images or logs.

### Docker Network vs Host Network

| Docker Network          | Host Network       |
| ----------------------- | ------------------ |
| Container isolation     | No isolation       |
| Internal DNS resolution | Direct host access |
| Secure by default       | Less secure        |

**Why Docker networks?**
They allow containers to communicate securely using service names instead of IPs.

### Docker Volumes with Bind Mounts

The project uses **Docker named volumes** configured with **bind mounts** to store data in `/home/your_login/data/`:

```yaml
volumes:
  db:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/your_login/data/db

  wordpress:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/your_login/data/wordpress
```

**Why this approach?**
- ✅ Uses Docker named volumes (required by subject)
- ✅ Stores data in `/home/your_login/data/` on host (required by subject)
- ✅ Direct host file access for development
- ✅ Data persists across container restarts

**Data locations:**
- `db` volume → `/home/your_login/data/db/` on host
- `wordpress` volume → `/home/your_login/data/wordpress/` on host

---

## Resources

- [Docker documentation](https://docs.docker.com)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [OpenSSL documentation](https://www.openssl.org/docs/)

---

## Use of AI

AI tools were used for:

- Understanding Docker and networking concepts
- Clarifying NGINX and TLS configuration
- Improving explanations and documentation clarity

All configuration, code, and architectural decisions were implemented and understood by the project author.

---

## Notes

- Only port 443 is exposed for HTTPS access
- TLS v1.3 is enforced
- Self-signed certificates are intentionally used
- No service runs as root unless required

---

## Author

Mohamed Dahmane (mohdahma)  
42 Network | 1337 Morocco
