FROM php:7.4-fpm

WORKDIR /var/www
RUN apt-get update && apt-get install -y \
    nodejs \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    locales \
    jpegoptim optipng pngquant gifsicle \
    zip unzip vim git curl fish

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions 
RUN docker-php-ext-install pdo_mysql zip opcache exif pcntl mbstring
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -m -s /bin/bash -g www www

COPY --chown=www:www . /var/www/

USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]