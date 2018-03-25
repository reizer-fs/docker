#!/bin/sh
set -e

[[ $DEBUG == true ]] && set -x

create_log_dir() {
  mkdir -p ${NGINX_LOG_DIR}
  chmod -R 0755 ${NGINX_LOG_DIR}
  chown -R ${NGINX_USER}:${NGINX_GROUP} ${NGINX_LOG_DIR}
}

create_tmp_dir(){
  mkdir -p ${NGINX_TEMP_DIR}
  chown -R ${NGINX_USER}:${NGINX_GROUP} ${NGINX_TEMP_DIR} 
}

create_siteconf_dir() {
  mkdir -p ${NGINX_SITECONF_DIR}
  chmod -R 755 ${NGINX_SITECONF_DIR}
}

change_owner_site_dir(){
  if [ ! -e "${NGINX_SITE_DIR}" ]; then
      mkdir -p ${NGINX_SITE_DIR}
  fi
  find ${NGINX_SITE_DIR} -type d -exec chmod 755 {} \;
  find ${NGINX_SITE_DIR} -type f -exec chmod 644 {} \;
  chown -R ${NGINX_USER}:${NGINX_GROUP} ${NGINX_SITE_DIR}
}

create_log_dir
create_tmp_dir
create_siteconf_dir
change_owner_site_dir

# default behaviour is to launch nginx
echo "Starting nginx..."
exec $(which nginx) -c /etc/nginx/nginx.conf -g "daemon off;" ${EXTRA_ARGS}
