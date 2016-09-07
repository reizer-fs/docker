#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MariaDB service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done


echo "=> Creating MariaDB admin user with $ADMIN_PASS password"

mysql -uroot -e "CREATE USER '$ADMIN_USER'@'%' IDENTIFIED BY '$ADMIN_PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$ADMIN_USER'@'%' IDENTIFIED BY '$RESTRICTED_USER_PASSWORD' WITH GRANT OPTION"

echo "=> Creating MariaDB $RESTRICTED_USER user with $RESTRICTED_USER_PASSWORD password"
mysql -uroot -e "CREATE USER '$RESTRICTED_USER'@'%' IDENTIFIED BY '$RESTRICTED_USER_PASSWORD'"

for DB in $RESTRICTED_DB ; do 
mysql -uroot -e "CREATE DATABASE '$DB'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB.* TO '$RESTRICTED_USER'@'%' IDENTIFIED BY '$RESTRICTED_USER_PASSWORD' WITH GRANT OPTION"
done


echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MariaDB Server using:"
echo ""
echo "    mysql -uadmin -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MariaDB user 'root' has no password but only allows local connections"
echo "========================================================================"

mysqladmin -uroot shutdown
