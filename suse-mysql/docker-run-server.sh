#!/bin/bash


help () {
        echo "Usage: $0 hostname type(optional)"
        echo "type = mysql apache squid samba torrent gitlab gcc"
}

if [ $# -lt 1 ] ; then
        help && exit 1
fi


HOSTNAME=$1
TYPE=$2
case $TYPE in
        mysql) CONTAINER="suse-mysql" ; PORTS="3306" ;;
        apache)CONTAINER="suse-apache" ; PORTS="80 443";;
        squid) CONTAINER="suse-squid" ; PORTS="3128" ;;
        samba) CONTAINER="suse-samba" ; PORTS="" ;;
        torrent) CONTAINER="suse-torrent";;
        gitlab) CONTAINER="suse-gitlab";;
        gcc) CONTAINER="suse-gcc";;
        *) help && exit 1 ;;
esac

VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$TYPE/$HOSTNAME"
DATA_VOLUMES="var/lib/mysql"

for i in $DATA_VOLUMES ; do
        if [ ! -d $ENV_DIRECTORY/$i ] ; then
                mkdir -p $ENV_DIRECTORY/$i
        fi

        if [ "$(ls -A $ENV_DIRECTORY/$i)" != "" ] ; then
                VOLUMES="$VOLUMES -v $ENV_DIRECTORY/$i:/$i"
        fi
done

docker run -d --name $HOSTNAME -p $VIP:3306:3306 \
-e ADMIN_USER="admin" \
-e ADMIN_PASS="admin" \
-e RESTRICTED_USER="dbuser" \
-e RESTRICTED_USER_PASSWORD="userpass" \
-e RESTRICTED_DB="db_" \
$VOLUMES \
$CONTAINER
