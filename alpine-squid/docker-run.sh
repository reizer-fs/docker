#!/bin/bash -x

NAME="alpine-squid"
IP_VHOST="10.11.12.105"

####
#PORTS_OPTS="-p $IP_VHOST:3128"
PORTS_OPTS="--publish-all"
sudo docker run -d -it -h $NAME --name $NAME $VOL_OPTS $PORTS_OPTS localhost/alpine-squid
