#!/bin/bash -x

NAME="alpine-squid"
IP_VHOST="10.11.66.131 10.11.12.125"

####
for IP in $IP_VHOST ; do
    PORTS_OPTS="$PORTS_OPTS -p $IP:3128:3128"
done
#PORTS_OPTS="--publish-all"

podman run -d -it -h $NAME --name $NAME $VOL_OPTS $PORTS_OPTS localhost/alpine-squid
sudo firewall-cmd --zone=public --add-port=3128/tcp --permanent
sudo firewall-cmd --reload
