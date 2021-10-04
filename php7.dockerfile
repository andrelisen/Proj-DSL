FROM php:7.2-apache

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libc-client-dev \
        libkrb5-dev \
    libicu-dev \
     libxml2-dev \
    vim \
        wget \
        unzip \
        git \
    && docker-php-ext-install -j$(nproc) iconv intl xml soap opcache pdo pdo_mysql mysqli mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && pecl install apcu \
    && pecl install apcu_bc-1.0.3 \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini    

#RUN a2enmod rewrite && mkdir /composer-setup && wget https://getcomposer.org/installer -P /composer-setup && php /composer-setup/installer --install-dir=/usr/bin && rm -Rf /composer-setup && curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && chmod a+x /usr/local/bin/symfony
# Create symlink for default conf
#RUN ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf && mkdir /composer-setup && wget https://getcomposer.org/installer -P /composer-setup && php /composer-setup/installer --install-dir=/usr/bin && rm -Rf /composer-setup && curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && chmod a+x /usr/local/bin/symfony