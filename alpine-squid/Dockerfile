FROM alpine

ENV SQUID_VERSION=3.5.27 \
    SQUID_CACHE_DIR=/var/cache/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid

# make sure the repositories are up to date
RUN apk update
RUN apk add squid
RUN rm -rf /var/cache/apk/*

EXPOSE 3128

COPY squid.conf /etc/squid/squid.conf
COPY ads.regexp /etc/squid/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
VOLUME ["${SQUID_CACHE_DIR}"]

CMD ["/sbin/entrypoint.sh"]
