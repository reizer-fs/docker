#!/bin/bash

if [ $# -lt 1 ] ; then
	echo "Usage: $0 hostname"
	exit 1
fi


HOSTNAME=$1
VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/git/$HOSTNAME"

if [ ! -d $ENV_DIRECTORY ] ; then
	mkdir -p $ENV_DIRECTORY
fi

docker run -it -d -h $HOSTNAME \
--name $HOSTNAME \
-p $VIP:22:22 \
-p $VIP:9418:9418 \
-p $VIP:80:80 \
-p $VIP:443:443 \
-v $ENV_DIRECTORY/repository:/data/repository \
suse-git
