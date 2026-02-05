.PHONY: all start stop clean fclean re logs

COMPOSE_FILE=./srcs/docker-compose.yml
DATA_DIR_DB=/home/mohdahma/data/db
DATA_DIR_WP=/home/mohdahma/data/wordpress

all: $(DATA_DIR_DB) $(DATA_DIR_WP)
	docker compose -f $(COMPOSE_FILE) up --build

$(DATA_DIR_DB):
	mkdir -p $@

$(DATA_DIR_WP):
	mkdir -p $@

start: $(DATA_DIR_DB) $(DATA_DIR_WP)
	docker compose -f $(COMPOSE_FILE) up -d

stop:
	docker compose -f $(COMPOSE_FILE) down

clean: stop
	@echo "Clean done"

fclean: stop
	docker compose -f $(COMPOSE_FILE) down -v --remove-orphans
	docker system prune -af --volumes
	sudo rm -rf $(DATA_DIR_WP) $(DATA_DIR_DB)
#--remove-orphans means remove even the containers created with docker-compose.yml but we remove them (we remove them from the yml file)

re: fclean all

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

logs-wp:
	docker compose -f $(COMPOSE_FILE) logs -f wordpress

logs-nginx:
	docker compose -f $(COMPOSE_FILE) logs -f nginx

logs-db:
	docker compose -f $(COMPOSE_FILE) logs -f mariadb

ps:
	docker compose -f $(COMPOSE_FILE) ps

help:
	@echo "Available targets:"
	@echo "  make all       - Build and start all services"
	@echo "  make start     - Start services (requires existing images)"
	@echo "  make stop      - Stop all services"
	@echo "  make clean     - Stop services and remove containers"
	@echo "  make fclean    - Remove everything including volumes"
	@echo "  make re        - Clean rebuild (fclean + all)"
	@echo "  make logs      - View all service logs"
	@echo "  make logs-wp   - View WordPress logs"
	@echo "  make logs-nginx- View NGINX logs"
	@echo "  make logs-db   - View MariaDB logs"
	@echo "  make ps        - Show running containers"
