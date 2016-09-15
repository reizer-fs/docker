#!/bin/bash


help () {
        echo "Usage: $0 hostname type(optional)"
	echo "type = mysql apache squid samba torrent gitlab gcc kali"
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
	kali) CONTAINER="kalilinux/kali-linux-docker";;
	*) help && exit 1 ;;
esac

VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$TYPE/$HOSTNAME"

if [ ! -d $ENV_DIRECTORY ] ; then
        mkdir -p $ENV_DIRECTORY
fi
docker run -it -d \
--name $HOSTNAME \
-h $HOSTNAME \
$CONTAINER
