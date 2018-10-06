VIP="alpine-samba"
IP_VHOST="192.168.56.1"
#IP_VHOST=`getent hosts $VIP | awk '{print $1}'`

LIB_DIR="/opt/ffx/scripts/libs"


##### Mount Options ####
#  name;/path[;browsable;readonly;guest;users;admins]"
####
VOL_OPTS='-v /data/iTunes:/data/iTunes -v /data/Downloads:/data/Downloads -v /data/Pictures:/data/Pictures'
MOUNT_OPTS='-s "iTunes;/data/iTunes;yes;no;yes;;ffx" -s "Downloads;/data/Downloads;yes;no;no;ffx" -s "Pictures;/data/Pictures;yes;no;no;ffx"'
PORTS_OPTS="-p $IP_VHOST:137:137 -p $IP_VHOST:139:139 -p $IP_VHOST:445:445"
AUTH_OPTS='-u "ffx;badpass" -n'
docker run -d --rm -h $VIP --name $VIP $VOL_OPTS $PORTS_OPTS alpine-samba $MOUNT_OPTS $AUTH_OPTS
