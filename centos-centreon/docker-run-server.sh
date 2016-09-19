#!/bin/sh

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
        apache)CONTAINER="suse-apache" ; PORTS="80 443" ;;
        squid) CONTAINER="suse-squid" ; PORTS="3128" ;;
        samba) CONTAINER="suse-samba" ; PORTS="" ;;
        torrent) CONTAINER="suse-torrent";;
        gitlab) CONTAINER="suse-gitlab";;
        gcc) CONTAINER="suse-gcc";;
        centreon) CONTAINER="centos-centreon-light" PORTS="80" ;;
        *) help && exit 1 ;;
esac

VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$TYPE/$HOSTNAME"
CONTAINER_DIR="usr/share/centreon etc/centreon etc/centreon-broker"

# Create data dir
if [ ! -d $ENV_DIRECTORY ] ; then
        mkdir -p $ENV_DIRECTORY
fi

# Check if host adress is fount
if [ -z $VIP ] ; then
	echo "Please add a entry for $HOSTNAME in /etc/hosts"
	exit 1
fi


for i in $CONTAINER_DIR ; do
	# Check if persistent data exist
        mkdir -p $ENV_DIRECTORY/$i
	if [ "$(ls -A $ENV_DIRECTORY/$i 2> /dev/null)" != "" ]; then
		DOCKER_VOLUMES="$DOCKER_VOLUMES -v $ENV_DIRECTORY/$i:/$i"
	fi
done


docker run -d --name $HOSTNAME \
-h $HOSTNAME \
-p $VIP:80:80 -p $VIP:443:443 \
$DOCKER_VOLUMES \
$CONTAINER
