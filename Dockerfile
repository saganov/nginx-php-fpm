FROM php:7.2.16-fpm-stretch

LABEL maintainer="Petr Saganov <saganoff@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends git ssh unzip libzip-dev nginx procps redis-tools
RUN docker-php-ext-configure zip --with-libzip
RUN docker-php-ext-install zip pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php-fpm.log

RUN mkdir -p /run/nginx && mkdir /run/php

COPY conf/default /etc/nginx/sites-enabled/default
RUN rm -rf /var/www/html/*

EXPOSE 80

COPY scripts/run.sh /

CMD ["/run.sh"]
