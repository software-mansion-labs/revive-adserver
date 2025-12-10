FROM alpine:3.19

# Install system dependencies
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache \
    nginx \
    php82@testing \
    php82-fpm@testing \
    php82-cli@testing \
    php82-ctype@testing \
    php82-curl@testing \
    php82-dom@testing \
    php82-fileinfo@testing \
    php82-gd@testing \
    php82-iconv@testing \
    php82-json@testing \
    php82-mbstring@testing \
    php82-mysqli@testing \
    php82-opcache@testing \
    php82-openssl@testing \
    php82-pdo@testing \
    php82-pdo_mysql@testing \
    php82-pdo_pgsql@testing \
    php82-pgsql@testing \
    php82-session@testing \
    php82-simplexml@testing \
    php82-tokenizer@testing \
    php82-xml@testing \
    php82-xmlreader@testing \
    php82-xmlwriter@testing \
    php82-zip@testing \
    php82-intl@testing \
    supervisor \
    wget \
    tzdata \
    netcat-openbsd \
    unzip

# Create php symlink for compatibility
RUN ln -sf /usr/bin/php82 /usr/bin/php

# Create nginx user and www-data group if not exists
RUN addgroup -S www-data 2>/dev/null || true && \
    adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G www-data nginx 2>/dev/null || true

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

# Remove default nginx configuration
RUN rm -f /etc/nginx/http.d/default.conf

# Copy configuration files
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf
COPY docker/php/php.ini /etc/php82/php.ini
COPY docker/php/www.conf /etc/php82/php-fpm.d/www.conf
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy scripts
COPY docker/scripts/entrypoint /usr/local/bin/entrypoint
COPY docker/scripts/start /usr/local/bin/start
RUN chmod +x /usr/local/bin/entrypoint && \
    chmod +x /usr/local/bin/start

# Create necessary directories
RUN mkdir -p /var/cache/nginx \
    /var/tmp/nginx \
    /run/nginx \
    /run/php-fpm82 \
    /var/www/html/var/cache \
    /var/www/html/var/plugins \
    /var/www/html/www/images \
    /var/www/html/www/delivery \
    /var/www/html/www/admin/plugins \
    /var/www/html/var/plugins/DataObjects \
    /var/www/html/var/templates_compiled

# Set proper permissions
RUN chown -R nginx:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/var \
    && chmod -R 777 /var/www/html/www/images \
    && chmod -R 777 /var/www/html/plugins \
    && chown -R nginx:www-data /var/cache/nginx \
    && chown -R nginx:www-data /run/nginx

# Test nginx configuration
RUN nginx -t

EXPOSE 80

# Set entrypoint and command
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["/usr/local/bin/start"]
