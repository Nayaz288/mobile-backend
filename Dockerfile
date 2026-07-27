FROM php:8.3-cli

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libpq-dev

RUN docker-php-ext-install pdo pdo_pgsql

COPY . .

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer install --no-dev --optimize-autoloader

RUN php artisan config:clear

EXPOSE 8080

CMD php artisan migrate --force && php -S 0.0.0.0:8080 -t public