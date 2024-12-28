FROM alpine:3.21

RUN apk update && apk upgrade && apk add --no-cache \
		mariadb \
		mariadb-client \
		bash
RUN rm -rf /var/lib/mysql/* /run/mysqld/*

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld && \
    chmod -R 750 /var/lib/mysql /run/mysqld

    
COPY ./conf/init.sh /init.sh
COPY ./conf/my.cnf /etc/my.cnf
    
RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/bin/bash", "init.sh"]
