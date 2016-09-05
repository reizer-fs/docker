#!/bin/bash

MARIADB_USER="mysql"
MARIADB_GROUP="mysql"
VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MariaDB volume is detected in $VOLUME_HOME"
    echo "=> Installing MariaDB ..."
    mysql_install_db > /dev/null 2>&1
    chown -R $MARIADB_USER:$MARIADB_GROUP $VOLUME_HOME
    echo "=> Done!"  
    /etc/create_mariadb_admin_user.sh
else
    echo "=> Using an existing volume of MariaDB"
    chown -R $MARIADB_USER:$MARIADB_GROUP $VOLUME_HOME
fi

exec mysqld_safe
