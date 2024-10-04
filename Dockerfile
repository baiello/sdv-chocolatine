FROM php:8.3-apache AS base

WORKDIR /app

COPY . .

ENV APACHE_DOCUMENT_ROOT=/app/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN echo "short_open_tag=Off" > /usr/local/etc/php/php.ini

RUN apt update && \
    apt install -y libicu-dev libpq-dev git zip && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl opcache pdo pdo_pgsql

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer install
