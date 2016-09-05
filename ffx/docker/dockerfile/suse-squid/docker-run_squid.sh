#!/bin/bash

if [ $# -lt 1 ] ; then
	echo "Usage: $0 hostname"
fi


HOSTNAME=$1
VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$HOSTNAME"

if [ ! -d $ENV_DIRECTORY ] ; then
	mkdir $ENV_DIRECTORY
fi

docker run -it -d -h $HOSTNAME \
--name $HOSTNAME \
-p $VIP:3130:3128 \
suse-squid
