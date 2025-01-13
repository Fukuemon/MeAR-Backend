#!/bin/bash
set -e

# マイグレーション実行
echo "Applying database migrations..."
if ! python manage.py makemigrations --noinput; then
    echo "Error: makemigrations failed."
    exit 1
fi

if ! python manage.py migrate --noinput; then
    echo "Error: migrate failed."
    exit 1
fi

# スーパーユーザー作成
echo "Creating superuser..."
if [ -n "$DJANGO_SUPERUSER_EMAIL" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
    echo "from django.contrib.auth import get_user_model; \
User = get_user_model(); \
User.objects.create_superuser('$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD') if not User.objects.filter(email='$DJANGO_SUPERUSER_EMAIL').exists() else print('Superuser already exists.')" | python manage.py shell
else
    echo "Warning: DJANGO_SUPERUSER_EMAIL or DJANGO_SUPERUSER_PASSWORD is not set. Skipping superuser creation."
fi

# アプリケーション起動
echo "Starting Gunicorn server..."
gunicorn --bind 0.0.0.0:8000 --worker-tmp-dir /app/temp config.wsgi:application