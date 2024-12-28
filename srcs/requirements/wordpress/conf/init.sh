#!/bin/sh

wordpress_setup () {
	echo "[DEBBUG] Wordpress config setup"
	wp config create --allow-root --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb
	database_ping;
	echo "[DEBBUG] Install and create admin user"
	wp core install --allow-root --url=$DOMAIN_NAME --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_PASSWD_ROOT --admin_email=$WP_MAIL
	if [ $? -eq 0 ]; then
		echo "[OK] WP install successful"
	else
		echo "[ERROR] WP install faild!"
		exit 1;
	fi
	echo "[DEBBUG] Create wordpress user: $WP_USER"
	wp user create $WP_USER $WP_MAIL --allow-root --user_pass=$WP_PASSWD --display_name=$WP_USER
	if [ $? -eq 0 ]; then
		echo "[OK] $WP_USER created"
	else
		echo "[ERROR] Faild to create user: $WP_USER!"
		exit 1;
	fi
}
database_ping () {
	echo "[INFO] Check db connection"
	wp db check
	if [ $? -eq 0 ]; then
		echo "[INFO] db connected"
	else
		echo "[ERROR] db connection faild!"
		exit 1;
	fi
}
wp config path 2>/dev/null
if [ $? -eq 0 ]; then
	echo "[OK] WP is install, skip installtion"
	database_ping;
else
	echo "[DEBBUG] WP not install"
	wordpress_setup;
fi
echo "[OK] Starting php-fpm"
php-fpm -F


# #!/bin/sh
# # if [ -f "/var/www/html/wordpress/wp-config.php" ] 

# # then
# # 	echo "Wordpress already confiured."
# # else   
# # wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# # chmod +x wp-cli.phar   
# # mv wp-cli.phar /usr/local/bin/wp   
# # wp core download --path=/var/www/wordpress --allow-root   
# # wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --path=/var/www/wordpress --skip-check --allow-root
# # wp core install --path=/var/www/wordpress --url=$DOMAIN_NAME --title=InceptionMyA** --admin_user=$MYSQL_USER --admin_password=$MYSQL_PASSWORD --admin_email=$WP_EMAIL --skip-email --allow-root
# # wp theme install teluro --path=/var/www/wordpress --activate --allow-root
# # wp user create leon leon@le.on --role=author --path=/var/www/wordpress --user_pass=leon --allow-root
# # fi
# # /usr/sbin/php-fpm -F

# # # create directory to use in nginx container later and also to setup the wordpress conf
# # mkdir /var/www/
# # mkdir /var/www/html

# # cd /var/www/html

# # # remove all the wordpress files if there is something from the volumes to install it again
# # rm -rf *

# # # The commands are for installing and using the WP-CLI tool.

# # # downloads the WP-CLI PHAR (PHP Archive) file from the GitHub repository. The -O flag tells curl to save the file with the same name as it has on the server.
# # curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 

# # # makes the WP-CLI PHAR file executable.
# # chmod +x wp-cli.phar 

# # # moves the WP-CLI PHAR file to the /usr/local/bin directory, which is in the system's PATH, and renames it to wp. This allows you to run the wp command from any directory
# # mv wp-cli.phar /usr/local/bin/wp

# # # downloads the latest version of WordPress to the current directory. The --allow-root flag allows the command to be run as the root user, which is necessary if you are logged in as the root user or if you are using WP-CLI with a system-level installation of WordPress.

# # wget https://wordpress.org/wordpress-6.2.2.tar.gz \
# #   && tar -zxvf wordpress-6.2.2.tar.gz \
# #   && mv wordpress/* . \
# #   && rm -rf wordpress wordpress-6.2.2.tar.gz \
# #   && chown -R wordpress:wordpress /var/www/html \
# #   && chmod -R 755 /var/www/html

# # mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# # # change the those lines in wp-config.php file to connect with database

# # #line 23
# # sed -i -r "s/database/$MYSQL_DATABASE/1"   wp-config.php
# # #line 26
# # sed -i -r "s/database_user/$MYSQL_USER/1"  wp-config.php
# # #line 29
# # sed -i -r "s/passwod/$MYSQL_PASSWORD/1"    wp-config.php

# # #line 32
# # sed -i -r "s/localhost/mariadb/1"    wp-config.php

# # installs WordPress and sets up the basic configuration for the site. The --url option specifies the URL of the site, --title sets the site's title, --admin_user and --admin_password set the username and password for the site's administrator account, and --admin_email sets the email address for the administrator. The --skip-email flag prevents WP-CLI from sending an email to the administrator with the login details.
# # if ! wp core is-installed --allow-root; then
# #     echo "Installing WordPress..."
# #     wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN" --admin_password="$WP_PASSWD_ROOT" --admin_email="$WP_MAIL" --skip-email --allow-root
# # else
# #     echo "WordPress is already installed."
# # fi
# # creates a new user account with the specified username, email address, and password. The --role option sets the user's role to author, which gives the user the ability to publish and manage their own posts.
# wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PASSWD --allow-root

# # installs the Astra theme and activates it for the site. The --activate flag tells WP-CLI to make the theme the active theme for the site.
# wp theme install astra --activate --allow-root

# # uses the sed command to modify the www.conf file in the /etc/php/7.4/fpm/pool.d directory. The s/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g command substitutes the value 9000 for /run/php/php7.4-fpm.sock throughout the file. This changes the socket that PHP-FPM listens on from a Unix domain socket to a TCP port.
# sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# # starts the PHP-FPM service in the foreground. The -F flag tells PHP-FPM to run in the foreground, rather than as a daemon in the background.
# /usr/sbin/php-fpm7.4 -F