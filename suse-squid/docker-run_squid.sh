#!/bin/bash -x

if [ $# -lt 1 ] ; then
	echo "Usage: $0 image hostname"
	exit 1
fi

LIB_DIR="/opt/ffx/scripts/libs"
. $LIB_DIR/systemd

HOSTNAME=$2
VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$HOSTNAME"

if [ ! -d $ENV_DIRECTORY ] ; then
	mkdir $ENV_DIRECTORY
fi

docker run -it -d -h $HOSTNAME \
--name $HOSTNAME \
-p $VIP:8080:3128 \
suse-squid

configure_docker_auto_start $HOSTNAME
