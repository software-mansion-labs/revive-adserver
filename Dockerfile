FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pgsql \
    pdo_pgsql \
    mysqli \
    pdo_mysql \
    zip \
    intl \
    gd \
    mbstring \
    xml \
    soap \
    opcache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy built package (will be provided during build)
# Accept package path as build arg
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

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/var \
    && chmod -R 777 /var/www/html/www/images \
    && chmod -R 777 /var/www/html/plugins

# Configure PHP
RUN echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/revive.ini \
    && echo "upload_max_filesize = 20M" >> /usr/local/etc/php/conf.d/revive.ini \
    && echo "post_max_size = 20M" >> /usr/local/etc/php/conf.d/revive.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/revive.ini

# Configure Apache
RUN echo "<Directory /var/www/html>" > /etc/apache2/conf-available/revive.conf \
    && echo "    Options -Indexes +FollowSymLinks" >> /etc/apache2/conf-available/revive.conf \
    && echo "    AllowOverride All" >> /etc/apache2/conf-available/revive.conf \
    && echo "    Require all granted" >> /etc/apache2/conf-available/revive.conf \
    && echo "</Directory>" >> /etc/apache2/conf-available/revive.conf \
    && a2enconf revive

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]

