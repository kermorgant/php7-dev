FROM php:5-apache
MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>
ENV REFRESHED_AT 2016-11-23

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libcurl4-gnutls-dev \
    libmcrypt-dev \
    libicu-dev \
    libxml2-dev  \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install gd curl \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-install soap gettext calendar zip \
    && docker-php-ext-install intl sockets exif

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN curl -LsS http://phpdox.de/releases/phpdox.phar -o /usr/local/bin/phpdox
RUN curl -LsS https://deployer.org/deployer.phar -o /usr/local/bin/dep
RUN curl -LsS wget https://phar.phpunit.de/phpunit.phar -o /usr/local/bin/phpunit
RUN chmod a+x /usr/local/bin/phpdox /usr/local/bin/dep /usr/local/bin/symfony

RUN composer global require "hirak/prestissimo:^0.3"
RUN pecl install xdebug

RUN ["cp", "/etc/apache2/mods-available/rewrite.load", "/etc/apache2/mods-enabled/"]


ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.9.1

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar -xJf node-v$NODE_VERSION-linux-x64.tar.xz -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs


RUN npm install -g zombie
RUN npm install -g bower

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www
ENTRYPOINT ["/entrypoint.sh"]
