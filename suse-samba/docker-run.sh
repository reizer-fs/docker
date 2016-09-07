VIP="samba"
IP_VHOST=`getent hosts $VIP | awk '{print $1}'`
ENV_DIRECTORY="/data/docker/samba"

docker run -h $VIP \
--name $VIP \
-p $IP_VHOST:139:139 -p $IP_VHOST:445:445 \
-d suse-samba \
-u "example1;badpass" \
-u "example2;badpass" \
-s "public;/share" \
-s "users;/srv;no;no;no;example1,example2" \
-s "example1 private;/example1;no;no;no;example1" \
-s "example2 private;/example2;no;no;no;example2"
