FROM php:7-fpm
MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>
ENV REFRESHED_AT 2016-10-26

RUN apt-get update && apt-get install -y \
    curl \
    git \
    libcurl4-gnutls-dev \
    libexif-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libpq-dev \
    libxml2-dev  \
    libgpgme11 \
    libgpgme11-dev \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install gnupg \
    && docker-php-ext-enable gnupg \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) gd curl \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install soap gettext calendar zip \
    && docker-php-ext-install intl sockets exif

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN curl -LsS http://phpdox.de/releases/phpdox.phar -o /usr/local/bin/phpdox
RUN curl -LsS https://deployer.org/deployer.phar -o /usr/local/bin/dep
RUN chmod a+x /usr/local/bin/phpdox /usr/local/bin/dep /usr/local/bin/symfony
RUN curl -LsS https://phar.phpunit.de/phpunit.phar -o /usr/local/bin/phpunit
RUN chmod a+x /usr/local/bin/phpdox /usr/local/bin/dep /usr/local/bin/symfony /usr/local/bin/phpunit


RUN composer global require "hirak/prestissimo:^0.3"
RUN pecl install xdebug

WORKDIR /var/www

COPY ["entrypoint.sh", "/"]
ENTRYPOINT ["/entrypoint.sh"]
