FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    wget              \
    mariadb-client    \
    php7.4            \
    php7.4-fpm        \
    php7.4-mysql      \
    php7.4-curl       \
    php7.4-gd         \
    php7.4-mbstring   \
    php7.4-intl       \
    php7.4-soap       \
    php7.4-xml        \
    php7.4-xmlrpc        \
    php7.4-zip

RUN mkdir -p /var/www/html
WORKDIR /var/www/html
RUN groupadd wordpress && useradd -g wordpress wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /bin/wp
COPY conf/php-fpm.conf /etc/php/7.4/fpm/
ADD conf/init.sh /
RUN chmod +x /init.sh

RUN ln -s $(which php-fpm7.4) /bin/php-fpm \
    && mkdir -p /usr/logs/php-fpm && chown -R wordpress:wordpress /usr/logs/php-fpm && chmod -R 755 /usr/logs/php-fpm \
    && mkdir -p /run/php/ && chown -R wordpress:wordpress /run/php/

RUN wget https://wordpress.org/wordpress-6.2.2.tar.gz && tar -zxvf wordpress-6.2.2.tar.gz

RUN mv wordpress/* . && rm -rf wordpress wordpress-6.2.2.tar.gz \
  && chown -R wordpress:wordpress /var/www/html && chmod -R 755 /var/www/html

USER wordpress:wordpress

ENTRYPOINT ["/bin/bash", "init.sh"]