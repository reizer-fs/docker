FROM opensuse:42.2

MAINTAINER Horus "horus@gmail.com"
#ENV http_proxy=http://proxy:8080/
#ENV https_proxy=http://proxy:8080/
ENV SQUID_VERSION=3.4.4 \
    SQUID_CACHE_DIR=/var/cache/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid

# make sure the repositories are up to date
RUN zypper ref -s
RUN zypper in --auto-agree-with-licenses -y squid

EXPOSE 3128

COPY squid.conf /etc/squid/squid.conf
COPY ads.regexp /etc/squid/
COPY entrypoint.sh /etc/entrypoint.sh
RUN chmod 755 /etc/entrypoint.sh

EXPOSE 3128/tcp
VOLUME ["${SQUID_CACHE_DIR}"]

CMD ["/bin/bash", "/etc/entrypoint.sh"]
