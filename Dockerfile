# Stage 1: Vue アプリをビルド
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG VITE_ACCESS_TOKEN
ENV VITE_ACCESS_TOKEN=$VITE_ACCESS_TOKEN
RUN npm run build

# Stage 2: nginx + PHP-FPM を1コンテナで運用
FROM nginx:alpine

# PHP-FPM と supervisor をインストール
RUN apk add --no-cache php83-fpm supervisor \
    && mkdir -p /var/www/api /var/www/data \
    && chown nobody:nobody /var/www/data

# Vue ビルド成果物
COPY --from=builder /app/dist /var/www/html

# PHP ファイル
COPY public/api/count.php /var/www/api/count.php

# nginx 設定
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# supervisor 設定
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
