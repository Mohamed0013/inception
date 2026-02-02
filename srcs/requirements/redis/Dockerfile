FROM debian:bookworm
# Base image: Use Debian Bookworm (lightweight Linux distribution)
# Why: Consistent with other services, minimal and secure

RUN apt update && apt install --no-install-recommends -y redis-server
# apt update: Refreshes package list from repositories
# apt install: Downloads and installs redis-server package
# --no-install-recommends: Skips optional dependencies (saves space)
# -y: Auto-confirms installation without asking
# Why: Redis needs to be installed to run the cache service

EXPOSE 6379
# EXPOSE: Documents that the container listens on port 6379
# 6379: Default Redis port for client connections
# Why: Other containers can connect to Redis on this port

CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]
# CMD: Default command when container starts
# redis-server: Starts Redis server
# --bind 0.0.0.0: Listen on all network interfaces (allows container communication)
# Why: Makes Redis accessible to WordPress container on the Docker network
