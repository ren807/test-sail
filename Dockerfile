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

# Composer と NPM の依存関係をインストール
RUN composer install
COPY package*.json ./
RUN npm install && npm run build

# Laravelキャッシュの作成
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

CMD php artisan serve --host=0.0.0.0 --port=8080

EXPOSE 8080
