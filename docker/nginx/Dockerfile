# Django 用ビルドステージ
FROM python:3.11 AS django

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

RUN python manage.py collectstatic --noinput

# Nginx 用ビルドステージ
FROM nginx:latest
# 環境変数を使ったテンプレートをコピー
COPY ./docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template

# 起動スクリプトを追加
COPY ./docker/nginx/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=django /app/staticfiles /usr/share/nginx/html/static
COPY --from=django /app/mediafiles /usr/share/nginx/html/media

EXPOSE 80

# カスタムエントリーポイントを指定
ENTRYPOINT ["/entrypoint.sh"]
