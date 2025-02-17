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
    xclip

# Composer のインストール
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 作業ディレクトリの設定
WORKDIR /var/www

# プロジェクトファイルをコンテナ内にコピー
COPY . .

# Composer と NPM の依存関係をインストール
RUN composer install

# NPM の依存関係をインストールしてビルド
RUN npm install && npm run build

# jQueryをインストール
RUN npm install jquery && npm run build

# artisan serve を使う
CMD ["sh", "-c", "php artisan serve --host=0.0.0.0 --port=$PORT"]

EXPOSE 8000
