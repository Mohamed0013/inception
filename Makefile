all :
	mkdir -p /home/mohdahma/data/db
	mkdir -p /home/mohdahma/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up --build

start:
	docker compose -f ./srcs/docker-compose.yml up -d

stop:
	docker compose -f ./srcs/docker-compose.yml down

clean:
	docker compose -f ./srcs/docker-compose.yml down

fclean:
	docker compose down -v --remove-orphans || true
	docker system prune -a -f --volumes
	sudo rm -rf /home/mohdahma/data/wordpress /home/mohdahma/data/db
