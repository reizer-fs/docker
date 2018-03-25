#!/bin/bash

APACHE_VERSION="2.4.10"
APACHE_MOUNT="/www"
APACHE_CONF="/etc/apache2/conf.d"
APACHE_DIR="/var/www"
APACHE_LOG_DIR="/var/log/apache2"
APACHE_USER="wwwrun"
APACHE_GROUP="www"

APACHE_INCLUDE_DIR="/etc/apache2/sysconfig.d"
chown -R $APACHE_USER:$APACHE_GROUP $APACHE_DIR

mkdir $APACHE_INCLUDE_DIR
touch $APACHE_INCLUDE_DIR/include.conf

#Specific to OpenSuse
sed -i 's/DocumentRoot.*/DocumentRoot "\/var\/www"/g' /etc/apache2/default-server.conf
sed -i -r 's/^upload_max_filesize.*$/upload_max_filesize = 20M/g' /etc/php5/apache2/php.ini
echo "LoadModule php5_module                    /usr/lib64/apache2/mod_php5.so" >> /etc/apache2/sysconfig.d/loadmodule.conf

a2enmod rewrite
a2enmod php 

apache2ctl -D FOREGROUND
