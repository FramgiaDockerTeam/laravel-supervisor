FROM php:7

MAINTAINER Tran Duc Thang <thangtd90@gmail.com>

ENV TERM xterm

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libmemcached-dev \
    curl \
    libjpeg-dev \
    libpng12-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    vim \
    supervisor \
    cron \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# configure gd library
RUN docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2

# Install mongodb, xdebug
RUN pecl install mongodb \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install extensions using the helper script provided by the base image
RUN docker-php-ext-install \
    mcrypt \
    pdo_mysql \
    pdo_pgsql \
    gd \
    zip

RUN usermod -u 1000 www-data

ADD laravel.ini /usr/local/etc/php/conf.d
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/laravel

# Default command
CMD ["/usr/bin/supervisord"]
