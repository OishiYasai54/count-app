# Stage 1: Vue アプリをビルド
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG VITE_ACCESS_TOKEN
ENV VITE_ACCESS_TOKEN=$VITE_ACCESS_TOKEN
RUN npm run build

# Stage 2: Nginx で配信
FROM nginx:alpine
COPY --from=builder /app/dist /var/www/html
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
