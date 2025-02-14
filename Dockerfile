# 基本となるイメージを選択
FROM php:8.4-fpm

# 必要な依存関係のインストール
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git curl unzip

# Composer のインストール
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node.js のインストール (必要に応じて)
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# 作業ディレクトリの設定
WORKDIR /var/www

# プロジェクトファイルをコンテナ内にコピー
COPY . .

# Composer と NPM の依存関係をインストール
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run prod

# エントリーポイントを指定 (Laravel Sail の実行)
CMD ["php-fpm"]
