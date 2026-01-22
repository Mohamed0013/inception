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
	docker system prune -a -f
	sudo rm -rf /home/mohdahma/data/wordpress/ /home/mohdahma/data/db/
