#!/bin/bash -x

if [ $# -lt 1 ] ; then
	echo "Usage: $0 image hostname"
	exit 1
fi

LIB_DIR="/opt/ffx/scripts/libs"
. $LIB_DIR/systemd

HOSTNAME=$2
VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/media/fx/3AD8C970D8C92AC9/Docker/Data/$HOSTNAME"

if [ ! -d $ENV_DIRECTORY ] ; then
	mkdir $ENV_DIRECTORY
fi

docker_run() $HOSTNAME
