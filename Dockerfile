# ==============================
# Nginx ステージ
# ==============================
FROM nginx:1.25-alpine AS nginx

# 必要なパッケージをインストール (envsubst)
RUN apk add --no-cache gettext

# 作業ディレクトリの設定
WORKDIR /var/www

# PHP-FPMステージからプロジェクトをコピー
COPY --from=php-fpm /var/www /var/www

# Nginxの設定テンプレートをコピー
COPY nginx.conf /etc/nginx/nginx.conf

# ポート設定
ENV PORT 8000
EXPOSE 8000

# 環境変数を適用して nginx.conf を生成
RUN envsubst '${PORT}' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf

# 🔽 Nginx設定ファイルの内容確認 (デバッグ用)
RUN echo "======= nginx.conf 内容 =======" && cat /etc/nginx/nginx.conf

# 🔽 Nginx設定の構文チェック
RUN nginx -t || (echo "Nginx 設定エラー: 構文が無効です" && exit 1)

# スクリプトで PHP-FPM と Nginx を両方起動
CMD sh -c "php-fpm & nginx -c /etc/nginx/nginx.conf -g 'daemon off;'"
