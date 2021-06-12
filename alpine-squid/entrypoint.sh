#!/bin/sh

set -e

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R $SQUID_USER $SQUID_LOG_DIR
}

create_cache_dir() {
  mkdir -p $SQUID_CACHE_DIR
  chown -R $SQUID_USER $SQUID_CACHE_DIR
}

start_squid () {
	squid -NYC
}

create_cache_dir () {
	squid -z -F &
        PID=$!
        wait $(pgrep -P $PID)
}

create_log_dir
create_cache_dir

echo "Starting squid..."
start_squid
