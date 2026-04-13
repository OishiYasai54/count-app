# CountUp App

Vue 3 + TypeScript + Vite で構築されたシンプルなフィットネスカウンターアプリです。
スマートフォンやタブレットでの操作に最適化されています。

## 特徴

- URL トークン認証（`?token=xxx`）でアクセス制御
- PHP-FPM によるカウントの永続化
- nginx + PHP-FPM を1コンテナで運用（supervisord）

## ローカル開発

```bash
cp .env.example .env
# .env を編集して VITE_ACCESS_TOKEN を設定

npm install
npm run dev
# Vite (localhost:5173) + PHP サーバー (localhost:8000) が同時起動
```

## ディレクトリ構成

```
├── src/                    # Vue フロントエンド
│   ├── components/
│   └── composables/
├── public/api/
│   └── count.php           # カウント API
├── docker/
│   ├── nginx.conf          # コンテナ内 Nginx 設定（port 3000）
│   └── supervisord.conf    # nginx + PHP-FPM 同時起動
├── infra/
│   ├── nginx.conf          # VPS ホスト Nginx vhost 設定
│   └── compose-fragment.yml # メイン compose サンプル
├── Dockerfile              # nginx + PHP-FPM の単一コンテナ
└── .env.example
```

## VPS デプロイ

### 初回

```bash
# リポジトリを配置
cd ~/services && git clone <repo-url> app1

# 環境変数を設定
cp ~/services/app1/.env.example ~/services/app1/.env
# ~/services/app1/.env を編集して VITE_ACCESS_TOKEN を設定

# Nginx vhost を配置
cp ~/services/app1/infra/nginx.conf ~/nginx/conf.d/app1.conf

# メイン compose にサービスを追記
# infra/compose-fragment.yml を参考に ~/services/docker-compose.yml に追記

# 起動
cd ~/services && docker compose up -d
```

### 更新

```bash
cd ~/services/app1 && git pull
cd ~/services && docker compose build countup --no-cache && docker compose up -d
```
