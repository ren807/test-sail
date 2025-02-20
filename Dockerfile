# PHP-FPM のインストール
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
    npm \
    nginx

# Composer のインストール
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 作業ディレクトリの設定
WORKDIR /var/www

# プロジェクトファイルをコンテナ内にコピー
COPY . .

# Composer と NPM の依存関係をインストール
RUN composer install
RUN npm install && npm run build

# キャッシュをクリアして最適化
RUN php artisan config:cache && php artisan optimize

# Nginx 設定をコンテナにコピー
COPY nginx.conf /etc/nginx/nginx.conf

# nginx と php-fpm を起動する
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]

# ポート 80 を公開
EXPOSE 80
