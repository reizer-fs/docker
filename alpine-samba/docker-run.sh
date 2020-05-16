#!/bin/bash -x

NAME="alpine-samba"
IP_VHOST="10.11.12.1"
#IP_VHOST=`getent hosts $VIP | awk '{print $1}'`

##### Mount Options ####
#  name;/path[;browsable;readonly;guest;users;admins]"
####
VOL_OPTS='-v /home/reizer/Softs:/data/Softs'
MOUNT_OPTS='-s Softs;/data/Softs;yes;no;yes'
PORTS_OPTS="-p $IP_VHOST:137:137 -p $IP_VHOST:139:139 -p $IP_VHOST:445:445"
AUTH_OPTS='-u reizer;badpass -n'
docker run -d -h $NAME --name $NAME $VOL_OPTS $PORTS_OPTS alpine-samba $MOUNT_OPTS $AUTH_OPTS
#docker run -d -it -h $NAME --name $NAME $VOL_OPTS $PORTS_OPTS --entrypoint "/bin/bash" alpine-samba
