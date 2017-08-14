#!/bin/bash


help () {
        echo "Usage: $0 hostname type(optional)"
        echo "type = mysql apache splunk splunk-light splunk-fw squid samba torrent gitlab gcc"
}

if [ $# -lt 1 ] ; then
        help && exit 1
fi


HOSTNAME=$1
TYPE=$2
LINKED_CONTAINER=$3

case $TYPE in
        mysql) IMAGE="suse-mysql" ; PORTS="3306" ;;
        apache)IMAGE="suse-apache" ; PORTS="80 443";;
        squid) IMAGE="suse-squid" ; PORTS="3128" ;;
        samba) IMAGE="suse-samba" ; PORTS="" ;;
        torrent) IMAGE="suse-torrent";;
        gitlab) IMAGE="suse-gitlab";;
        gcc) IMAGE="suse-gcc";;
        splunk) IMAGE="suse-splunk"; PORTS="8000 443 9997";;
        splunk-light) IMAGE="suse-splunk-light"; PORTS="8000 443";;
        splunk-fw) IMAGE="suse-splunk-fw"; PORTS="8089";;
        *) help && exit 1 ;;
esac

VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$TYPE/$HOSTNAME"
DATA_VOLUMES=""

if [ ! -z "$LINKED_CONTAINER" ] ; then
        EXTRA_OPTS="$EXTRA_OPTS --link $LINKED_CONTAINER "
fi

if [ ! -z "$PORTS" ] ; then
	for PORT in $PORTS ; do
        	EXTRA_OPTS="$EXTRA_OPTS -p $VIP:$PORT:$PORT "
	done
fi

if [ ! -z "$DATA_VOLUMES" ] ; then
	for i in $DATA_VOLUMES ; do
		if [ ! -d $ENV_DIRECTORY/$i ] ; then
			mkdir -p $ENV_DIRECTORY/$i
		fi

		if [ "$(ls -A $ENV_DIRECTORY/$i)" != "" ] ; then
			VOLUMES="$VOLUMES -v $ENV_DIRECTORY/$i:/$i "
		fi
	done
fi

docker run -d --name $HOSTNAME \
-h $HOSTNAME \
$VOLUMES \
$EXTRA_OPTS \
-e SPLUNK_START_ARGS="--accept-license --answer-yes --no-prompt" \
$IMAGE
