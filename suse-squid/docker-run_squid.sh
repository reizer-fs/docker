#!/bin/bash -x

if [ $# -lt 1 ] ; then
	echo "Usage: $0 hostname"
fi

LIB_DIR="/opt/ffx/scripts/libs"
source $LIB_DIR/systemd

HOSTNAME=$1
VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$HOSTNAME"

if [ ! -d $ENV_DIRECTORY ] ; then
	mkdir $ENV_DIRECTORY
fi

docker run -it -d -h $HOSTNAME \
--name $HOSTNAME \
-p $VIP:8080:3128 \
suse-squid

if [ $0 = "0" ]; then
	configure_docker_auto_start $HOSTNAME
fi
