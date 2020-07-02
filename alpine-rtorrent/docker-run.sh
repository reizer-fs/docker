#!/bin/bash -x

NAME="rtorrent"

####
#PORTS_CFG="--publish-all"
CPU_CFG="--cpus=1"
MEM_CFG="--memory=1g"
VOL_CFG="-v /home/reizer/Downloads:/var/data/"

### Podman ###
#sudo docker run -d -it -h $NAME --name $NAME $VOL_OPTS $PORTS_OPTS localhost/alpine-torrent

### Docker ###
sudo docker run -d -it -h $NAME --name $NAME $CPU_CFG $MEM_CFG $VOL_CFG $PORTS_CFG alpine-rtorrent
