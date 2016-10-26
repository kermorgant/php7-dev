FROM php:7-fpm
MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>
ENV REFRESHED_AT 2016-10-26

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libcurl4-gnutls-dev \
    libmcrypt-dev \
    libicu-dev \
    libxml2-dev  \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install gd curl \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-install soap gettext calendar zip \
    && docker-php-ext-install intl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

RUN curl -LsS http://phpdox.de/releases/phpdox.phar -o /usr/local/bin/phpdox
RUN chmod a+x /usr/local/bin/phpdox

RUN pecl install xdebug

WORKDIR /var/www
