FROM debian:bullseye

RUN apt update && apt install -y --no-install-recommends \
	mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/create_db.sh /usr/local/bin/create_db.sh
RUN chmod +x /usr/local/bin/create_db.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/create_db.sh"]