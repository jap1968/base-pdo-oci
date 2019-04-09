FROM ubuntu:18.04
MAINTAINER josean1968@gmail.com

ENV TZ="Europe/Madrid"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN apt update \
    && apt install -y \
        php-xml \
        php-zip \
        php-mbstring \
        php-gd \
        language-pack-es \
        apache2 \
        libapache2-mod-php \
        php7.2-dev \
        libaio1 \
        gcc \
        make \
    && apt-get clean \
    && apt-get autoremove

# Get Oracle Instant-Client drivers (v18.5) from:
# https://www.oracle.com/technetwork/database/database-technologies/instant-client/overview/index.html
# https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
# Previously converted from .rpm to .deb with alien
# sudo alien oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm
# sudo alien oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm
COPY /files/oracle/* /tmp/
RUN dpkg -i /tmp/oracle-instantclient18.5-basic_18.5.0.0.0-4_amd64.deb \
    && dpkg -i /tmp/oracle-instantclient18.5-devel_18.5.0.0.0-4_amd64.deb \
    && rm -f /tmp/oracle-instantclient18.5-basic_18.5.0.0.0-4_amd64.deb \
    && rm -f /tmp/oracle-instantclient18.5-devel_18.5.0.0.0-4_amd64.deb

# Install the OCI8 extension
RUN curl https://pecl.php.net/get/oci8-2.2.0.tgz \
    | tar -xzC /usr/local/src/ \
    && cd /usr/local/src/oci8-2.2.0 \
    && phpize \
    && ./configure --with-oci8=instantclient,/usr/lib/oracle/18.5/client64/lib \
    && make install \
    && cd \
    && rm -rf /usr/local/src/oci8-2.2.0 \
    && echo extension=oci8.so > /etc/php/7.2/mods-available/oci8.ini \
    && phpenmod oci8 \
    && echo /usr/lib/oracle/18.5/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

# Install the PDO_OCI extension
RUN curl -L http://php.net/get/php-7.2.15.tar.bz2/from/a/mirror \
    | tar -xjC /usr/local/src/ php-7.2.15/ext/pdo_oci \
    && cd /usr/local/src/php-7.2.15/ext/pdo_oci/ \
    && phpize \
    && ./configure --with-pdo-oci=instantclient,/usr/lib/oracle/18.5/client64/lib \
    && make install \
    && cd \
    && rm -rf /usr/local/src/php-7.2.15/ \
    && echo extension=pdo_oci.so > /etc/php/7.2/mods-available/pdo_oci.ini \
    && phpenmod pdo_oci

COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY src /var/local/www/src
COPY public /var/local/www/public
RUN mkdir /var/local/www/logs \
    && chmod 777 /var/local/www/logs

WORKDIR /var/local/www/
RUN echo "<?php phpinfo();" > /var/local/www/public/info.php
RUN a2enmod rewrite

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
