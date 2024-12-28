#!/bin/bash

# Allow us to check if env are correctly set
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "Error: One or more required environment variables are missing."
    exit 1
fi

chown -R mysql:mysql /var/lib/mysql /run/mysqld && \
chmod -R 750 /var/lib/mysql /run/mysqld

# Check if mariadb install and the data directory is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Initialize mariadb without netwotrking
mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking & 
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB to start..."
    sleep 1
done

# Setup database and config
mariadb -u root -e "DROP DATABASE test;"
mariadb -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');"
mariadb -u root -e "CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8 COLLATE utf8_general_ci;"
mariadb -u root -e "CREATE USER 'wordpress'@'%' IDENTIFIED by '${MYSQL_PASSWORD}';"
mariadb -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';"
mariadb -u root -e "FLUSH PRIVILEGES;"

# Kill the MySQL process so we can restart it properly
mysqladmin -u root --password=${MYSQL_ROOT_PASSWORD} shutdown
sed -i 's/bind-address/#bind-address/' /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
chmod -R 777 /var/lib/mysql
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Start mariadb normally
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql