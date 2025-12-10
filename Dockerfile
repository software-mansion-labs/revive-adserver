FROM php:8.2-fpm-alpine3.19

# Install system dependencies (nginx + supervisor + tools)
RUN apk add --no-cache \
    nginx \
    supervisor \
    tzdata \
    netcat-openbsd \
    unzip

# Set working directory
WORKDIR /var/www/html

# Copy built package (will be provided during build)
ARG PACKAGE_PATH
COPY ${PACKAGE_PATH} /tmp/package.tar.gz

# Extract package
RUN if [ -f /tmp/package.tar.gz ]; then \
        tar -xzf /tmp/package.tar.gz -C /tmp/ && \
        PACKAGE_DIR=$(ls -d /tmp/revive-adserver-* 2>/dev/null | head -1) && \
        if [ -n "$PACKAGE_DIR" ]; then \
            mv $PACKAGE_DIR/* /var/www/html/ && \
            mv $PACKAGE_DIR/.* /var/www/html/ 2>/dev/null || true; \
        fi && \
        rm -rf /tmp/revive-adserver-* /tmp/package.tar.gz; \
    else \
        echo "Error: Package file not found at ${PACKAGE_PATH}"; \
        echo "Please build the package first with 'ant package'"; \
        exit 1; \
    fi

# Copy configuration files
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf
COPY docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy scripts
COPY docker/scripts/entrypoint /usr/local/bin/entrypoint
COPY docker/scripts/start /usr/local/bin/start
RUN chmod +x /usr/local/bin/entrypoint /usr/local/bin/start

# Create necessary directories
RUN mkdir -p /var/cache/nginx \
    /var/tmp/nginx \
    /run/nginx \
    /run/php-fpm \
    /var/www/html/var/cache \
    /var/www/html/var/plugins \
    /var/www/html/www/images \
    /var/www/html/www/delivery \
    /var/www/html/www/admin/plugins \
    /var/www/html/var/plugins/DataObjects \
    /var/www/html/var/templates_compiled

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/var \
    && chmod -R 777 /var/www/html/www/images \
    && chmod -R 777 /var/www/html/var/plugins \
    && chown -R www-data:www-data /var/cache/nginx /run/nginx /run/php-fpm

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["/usr/local/bin/start"]
