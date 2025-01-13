#!/bin/bash
set -e

# 環境変数を置き換えてNginx設定ファイルを生成
envsubst '${APP_HOST} ${APP_PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Nginxを起動
exec nginx -g "daemon off;"
