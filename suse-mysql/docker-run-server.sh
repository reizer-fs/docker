#!/bin/sh

ENV_DIRECTORY="/data/docker/mysql/ffx"

docker run -d --name mysql-ffx -p 192.168.127.203:3306:3306 \
-e ADMIN_USER="admin" \
-e ADMIN_PASS="admin" \
-e RESTRICTED_USER="wordpress" \
-e RESTRICTED_USER_PASSWORD="wordpress" \
-e RESTRICTED_DB="wordpress" \
-v $ENV_DIRECTORY/var/lib/mysql:/var/lib/mysql \
suse-mysql
#-v $ENV_DIRECTORY/etc/mysql:/etc/mysql \
