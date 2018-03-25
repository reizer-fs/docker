#!/bin/bash

set -eu

#service mysql start
#/etc/init.d/mysql start
/usr/sbin/mysqld --initialize-insecure --user=mysql
/usr/sbin/mysqld --user=mysql &
sleep 5

# Create Orchestrator db.
mysql -vv -e "CREATE DATABASE IF NOT EXISTS orchestrator; GRANT ALL PRIVILEGES ON orchestrator.* TO 'orchestrator'@'localhost' IDENTIFIED BY 'orchestrator'"

# Install QAN API.
# START=no SYSINT=no because Supervisor starts and manages these processes.
cd /opt/qan-api
START="no" SYSINT="no" ./install

# Define /qan-api path for QAN app
sed -i "s/':9001',/':' + window.location.port + '\/qan-api',/" /opt/qan-app/client/app/app.js
