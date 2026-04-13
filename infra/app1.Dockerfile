# Stage 1: Vue アプリをビルド
FROM node:22-alpine AS builder
WORKDIR /app
COPY repo/count-app/package*.json ./
RUN npm ci
COPY repo/count-app/ .
ARG VITE_ACCESS_TOKEN
ENV VITE_ACCESS_TOKEN=$VITE_ACCESS_TOKEN
RUN npm run build

# Stage 2: nginx + PHP-FPM を1コンテナで運用
FROM nginx:alpine

RUN apk add --no-cache php83-fpm supervisor \
    && mkdir -p /var/www/api /var/www/data \
    && chown nobody:nobody /var/www/data

ENV DATA_DIR=/var/www/data

COPY --from=builder /app/dist /var/www/html
COPY repo/count-app/public/api/count.php /var/www/api/count.php
COPY repo/count-app/docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY repo/count-app/docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
