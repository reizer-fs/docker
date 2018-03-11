#!/bin/sh

set -e

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER} ${SQUID_CACHE_DIR}
}

start_squid () {
	squid -NYC
}

create_cache_dir () {
	squid -z -F
}

create_log_dir
create_cache_dir

if [[ -z ${1} ]]; then
	if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
		echo "Initializing cache..."
		create_cache_dir || echo "Initializing cache failed, retrying ..." && create_cache_dir
	fi
	echo "Starting squid..."
	start_squid
fi
