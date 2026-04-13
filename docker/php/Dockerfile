FROM php:8.2-fpm-alpine
COPY public/api/count.php /var/www/api/count.php
# データ永続化ディレクトリ（volume でマウントされる）
RUN mkdir -p /var/www/data && chown www-data:www-data /var/www/data
