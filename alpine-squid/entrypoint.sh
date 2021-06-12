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

create_cache_dir () {
        squid -z -F &
        PID=$!
        wait $(pgrep -P $PID)
}

create_log_dir
create_cache_dir
sleep 5

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid..."
  exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
