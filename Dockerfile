FROM ubuntu:18.04
MAINTAINER josean1968@gmail.com

ENV TZ="Europe/Madrid"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN apt update \
    && apt install -y \
        unzip \
        apache2 \
        libapache2-mod-php \
        language-pack-es \
        php-dev \
        php-mbstring \
        libaio1 \
        gcc \
        make

# Get Oracle Instant Client drivers (v18.5) from:
# https://www.oracle.com/technetwork/database/database-technologies/instant-client/overview/index.html
# https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
COPY /files/oracle/instantclient* /tmp/
RUN unzip /tmp/instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip -d /opt/ \
    && rm -f /tmp/instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip \
    && unzip /tmp/instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip -d /opt/ \
    && rm -f /tmp/instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip \
    && echo /opt/instantclient_18_5 > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

## Install the OCI8 extension
#RUN curl https://pecl.php.net/get/oci8-2.2.0.tgz \
#    | tar -xzC /usr/local/src/ \
#    && cd /usr/local/src/oci8-2.2.0 \
#    && phpize \
#    && ./configure --with-oci8=instantclient,/opt/instantclient_18_5 \
#    && make install \
#    && cd \
#    && rm -rf /usr/local/src/oci8-2.2.0 \
#    && echo extension=oci8.so > /etc/php/7.2/mods-available/oci8.ini \
#    && phpenmod oci8

# Install the PDO_OCI extension
RUN curl -L http://php.net/get/php-7.2.15.tar.bz2/from/a/mirror \
    | tar -xjC /usr/local/src/ php-7.2.15/ext/pdo_oci \
    && cd /usr/local/src/php-7.2.15/ext/pdo_oci/ \
    && phpize \
    && ./configure --with-pdo-oci=instantclient,/opt/instantclient_18_5 \
    && make install \
    && cd \
    && rm -rf /usr/local/src/php-7.2.15/ \
    && echo extension=pdo_oci.so > /etc/php/7.2/mods-available/pdo_oci.ini \
    && phpenmod pdo_oci

COPY /files/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/local/www/
RUN mkdir /var/local/www/public/ \
    && echo "<?php phpinfo();" > /var/local/www/public/info.php
RUN a2enmod rewrite

# COPY src /var/local/www/src
# COPY public /var/local/www/public
# RUN mkdir /var/local/www/logs \
#     && chmod 777 /var/local/www/logs

# CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
