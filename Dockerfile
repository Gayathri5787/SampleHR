FROM webdevops/php-nginx:8.3

# Make nginx serve Laravel's public/
ENV WEB_DOCUMENT_ROOT=/var/www/html/public
ENV WEB_DOCUMENT_INDEX=index.php

WORKDIR /var/www/html
COPY . .

# Silence the composer root warning (optional but nice)
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader \
    && php artisan config:clear && php artisan cache:clear \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache \
    && php artisan storage:link || true

EXPOSE 80
CMD ["supervisord"]
