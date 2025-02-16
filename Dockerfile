# 基本となるイメージを選択
FROM php:8.4-fpm-alpine AS php-fpm

# 必要な依存関係をインストール
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zip \
    git \
    curl \
    unzip \
    bash \
    nodejs \
    npm

# Composer のインストール
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 作業ディレクトリの設定
WORKDIR /var/www

# プロジェクトファイルをコンテナ内にコピー
COPY . .

# 権限を設定
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Composer と NPM の依存関係をインストール
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build

# Laravelキャッシュの作成
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

# Nginxステージ
FROM nginx:1.25-alpine AS nginx

# 作業ディレクトリの設定
WORKDIR /var/www

# PHP-FPMステージからプロジェクトをコピー
COPY --from=php-fpm /var/www /var/www

# Nginxの設定をコピー
COPY nginx.conf /etc/nginx/nginx.conf

# ポート設定
ENV PORT 8000
EXPOSE 8000

# コンテナ起動時のコマンド
CMD ["nginx", "-g", "daemon off;"]
