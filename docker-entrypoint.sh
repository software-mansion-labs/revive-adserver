#!/bin/bash
set -e

# Fix permissions on startup
chown -R www-data:www-data /var/www/html/var || true
chmod -R 777 /var/www/html/var || true
chmod -R 777 /var/www/html/www/images || true
chmod -R 777 /var/www/html/plugins || true

# Wait for database to be ready (if using docker-compose)
if [ -n "$DB_HOST" ]; then
    echo "Waiting for database to be ready..."
    until php -r "new PDO('pgsql:host=${DB_HOST};port=${DB_PORT:-5432};dbname=${DB_NAME}', '${DB_USER}', '${DB_PASSWORD}');" 2>/dev/null; do
        echo "Database is unavailable - sleeping"
        sleep 1
    done
    echo "Database is up - continuing"
fi

# Execute the main command
exec "$@"

