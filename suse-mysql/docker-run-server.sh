#!/bin/bash


help () {
        echo "Usage: $0 hostname type(optional)"
        echo "type = mysql apache squid samba torrent gitlab gcc"
}

if [ $# -lt 1 ] ; then
        help && exit 1
fi

HOSTNAME=$1
TYPE=$2

case $TYPE in
        mysql|mariadb) 
		CONTAINER="suse-mysql"
		PORTS="3306"
		DATA_VOLUMES="var/lib/mysql"
		ADMIN_USER="$ADMIN_USER"
		ADMIN_PASS="$ADMIN_PASS"
		RESTRICTED_USER="$RESTRICTED_USER"
		RESTRICTED_USER_PASSWORD="$RESTRICTED_USER_PASSWORD"
		RESTRICTED_DB="$RESTRICTED_DB"
		;;
        apache)
		CONTAINER="suse-apache" 
		PORTS="80 443";;
        squid) 
		CONTAINER="suse-squid"
		PORTS="3128" ;;
        samba) 
		CONTAINER="suse-samba"
		PORTS="137 139 445" ;;
        torrent) 
		CONTAINER="suse-torrent";;
        gitlab) 
		CONTAINER="suse-gitlab";;
        gcc) 
		CONTAINER="suse-gcc";;
        splunk) CONTAINER="suse-splunk";;
        *) help && exit 1 ;;
esac

VIP=`getent hosts $HOSTNAME | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/$TYPE/$HOSTNAME"


# PORT PUBLICATION
if [ -z $PORTS ]; then
	EXTRAOPTIONS="--publish-all=true"
fi
	
# Handling data volume
if [ ! -z $DATA_VOLUMES ] ; then
	for i in $DATA_VOLUMES ; do
		if [ ! -d $ENV_DIRECTORY/$i ] ; then
			mkdir -p $ENV_DIRECTORY/$i
		fi

		if [ "$(ls -A $ENV_DIRECTORY/$i)" != "" ] ; then
			VOLUMES="$VOLUMES -v $ENV_DIRECTORY/$i:/$i"
		fi
	done
fi

# Handling data volume
if [ ! -z $PORTS ] ; then
	for i in $PORTS ; do
		PORT=" $PORT -p $VIP:$i:$i"
	done
fi

docker run -d --name $HOSTNAME -h $HOSTNAME $PORT $VOLUMES $EXTRAOPTIONS $CONTAINER

if [ $? = "0" ]; then
	cp /opt/ffx/systems/ubuntu/etc/systemd/system/docker.template /etc/systemd/system/docker-$HOSTNAME.service
	sed -i "s/container/$HOSTNAME/" /etc/systemd/system/docker-$HOSTNAME.service
	systemctl daemon-reload
fi
