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
LINKED_CONTAINER=$3

case $TYPE in
        mysql) CONTAINER="suse-mysql" ; PORTS="3306" ;;
        apache)CONTAINER="suse-apache" ; PORTS="80 443";;
        squid) CONTAINER="suse-squid" ; PORTS="3128" ;;
        samba) CONTAINER="suse-samba" ; PORTS="" ;;
        torrent) CONTAINER="suse-torrent";;
        gitlab) CONTAINER="suse-gitlab";;
        gcc) CONTAINER="suse-gcc";;
        splunk) CONTAINER="suse-splunk"; PORTS="8000 443";;
        splunk-light) CONTAINER="suse-splunk-light"; PORTS="8000 443";;
        *) help && exit 1 ;;
esac

VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/splunk/$HOSTNAME"
DATA_VOLUMES=""

if [ ! -z $LINKED_CONTAINER ] ; then
        EXTRA_OPTS="$EXTRA_OPTS --link $LINKED_CONTAINER"
fi


for i in $DATA_VOLUMES ; do
        if [ ! -d $ENV_DIRECTORY/$i ] ; then
                mkdir -p $ENV_DIRECTORY/$i
        fi

        if [ "$(ls -A $ENV_DIRECTORY/$i)" != "" ] ; then
                VOLUMES="$VOLUMES -v $ENV_DIRECTORY/$i:/$i"
        fi
done
docker run -d --name $HOSTNAME \
-h $HOSTNAME \
-p $VIP:80:8000 -p $VIP:443:443 \
$VOLUMES \
$EXTRA_OPTS \
-e SPLUNK_START_ARGS="--accept-license --answer-yes --no-prompt" \
$CONTAINER
