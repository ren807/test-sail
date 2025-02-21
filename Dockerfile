# richarvey/nginx-php-fpmをベースとする
FROM richarvey/nginx-php-fpm:2.1.2

# Node.js と npm をインストール
RUN apk add --no-cache nodejs npm

COPY . .

# Image config
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Vite ビルドを実行
RUN npm install && npm run build

CMD ["/start.sh"]
