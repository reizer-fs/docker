#!/bin/bash

docker_port="86"
docker_remote_port="80"
docker_type="app_http"
docker_conf_dir=""
docker_data_dir=""
docker_log_dir=""
docker_cert_dir=""

EXTRA_OPTS=""
#CMD="docker run $EXTRA_OPTS"

if [ ! -z $docker_port ]; then
	$EXTRA_OPTS="$EXTRA_OPTS -p $docker_port"
fi
echo "$EXTRA_OPTS"

#docker run -d -p 80:80 -v $docker_conf_dir:/etc/nginx/conf.d -v $docker_cert_dir:/etc/nginx/certs -v $docker_log_dir:/var/log/nginx -v $docker_data_dir:/var/www/html opensuse/nginx
