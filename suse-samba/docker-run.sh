VIP="suse-samba"
ENV_DIRECTORY="/data/docker/samba/$VIP"
SAMBA_DIR="box downloads"
IP_VHOST=`getent hosts $VIP | awk '{print $1}'`

LIB_DIR="/opt/ffx/scripts/libs"
. $LIB_DIR/systemd

if [ ! -d $ENV_DIRECTORY ] ; then
	mkdir -p $ENV_DIRECTORY/shares
	mkdir -p $ENV_DIRECTORY/etc/
fi

if [ "$(ls -A $ENV_DIRECTORY/etc 2> /dev/null)" != "" ]; then
	DOCKER_VOLUMES=" -v $ENV_DIRECTORY/etc/:/etc/samba/"
fi

for i in $SAMBA_DIR ; do 
	mkdir -p $ENV_DIRECTORY/shares/$i
	DOCKER_VOLUMES="$DOCKER_VOLUMES -v $ENV_DIRECTORY/shares/$i:/shares/$i"
done

docker run -it -h $VIP \
--name $VIP \
-p $IP_VHOST:137:137 $IP_VHOST:139:139 -p $IP_VHOST:445:445 \
$DOCKER_VOLUMES \
-d suse-samba \
-u "ffx;badpass" \
-s "IN_BOX;/shares/box;yes;no;yes;;ffx" \
-s "DOWNLOADS;/shares/downloads;yes;no;no;ffx" \
-n

configure_docker_auto_start $VIP
