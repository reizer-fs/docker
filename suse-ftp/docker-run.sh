VIP="ftp"
ENV_DIRECTORY="/data/docker/ftp/$VIP"
FTP_DIR="box downloads"
IP_VHOST=`getent hosts $VIP | awk '{print $1}'`

if [ ! -d $ENV_DIRECTORY ] ; then
	mkdir -p $ENV_DIRECTORY/shares
	mkdir -p $ENV_DIRECTORY/etc/
fi

if [ "$(ls -A $ENV_DIRECTORY/etc 2> /dev/null)" != "" ]; then
	DOCKER_VOLUMES=" -v $ENV_DIRECTORY/etc/:/etc/proftpd/"
fi

for i in $FTP_DIR ; do 
	mkdir -p $ENV_DIRECTORY/shares/$i
	DOCKER_VOLUMES="$DOCKER_VOLUMES -v $ENV_DIRECTORY/shares/$i:/shares/$i"
done

docker run -it -h $VIP \
--name $VIP \
-p $IP_VHOST:20:20 -p $IP_VHOST:21:21 \
$DOCKER_VOLUMES \
-d suse-ftp \
-e USERNAME=ffx \
-e PASSWORD=passwd
