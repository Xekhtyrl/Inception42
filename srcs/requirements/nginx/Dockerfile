FROM alpine:3.21

RUN apk update && apk upgrade && apk add \
		nginx	\
		curl	\
		openssl

# COPY ./conf/nginx.conf  /etc/nginx/sites-enabled/nginx.conf
COPY ./conf/nginx.conf  /etc/nginx/nginx.conf
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
-subj "/CN=lvodak.42.fr/C=FR/L=Paris/O=lvodak@42" \
-keyout /etc/nginx/ssl/inception.key \
-out /etc/nginx/ssl/inception.crt
EXPOSE 443
RUN mkdir -p /var/run/nginx
#/etc/nginx/nginx.conf
RUN mkdir -p /var/www/html
COPY conf/404.html /var/html/
COPY conf/502.html /var/html/
RUN chmod 755 /var/www/html
RUN chown -R root:root /var/www/html

# HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
# CMD curl -f https://localhost || exit 1

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]