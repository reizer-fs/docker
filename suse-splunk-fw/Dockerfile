FROM opensuse:42.2

MAINTAINER Sebastian Petrovich <docker-splunk@gmail.com>

ENV SPLUNK_PRODUCT universalforwarder
ENV SPLUNK_VERSION 6.6.2
ENV SPLUNK_BUILD 4b804538c686
ENV SPLUNK_FILENAME splunkforwarder-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz
ENV SPLUNK_HOME /opt/splunk
ENV SPLUNK_GROUP splunk
ENV SPLUNK_USER splunk
ENV SPLUNK_BACKUP_DEFAULT_ETC /var/opt/splunk

# add splunk:splunk user
RUN groupadd -r ${SPLUNK_GROUP} \
    && useradd -r -m -g ${SPLUNK_GROUP} ${SPLUNK_USER}

ENV LANG en_US.utf8

# Download official Splunk release, verify checksum and unzip in /opt/splunk
# Also backup etc folder, so it will be later copied to the linked volume
RUN zypper in -y wget tar sudo \
    && mkdir -p ${SPLUNK_HOME} \
    && wget -qO /tmp/${SPLUNK_FILENAME} https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME} \
    && wget -qO /tmp/${SPLUNK_FILENAME}.md5 https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}.md5 \
    && (cd /tmp && md5sum -c ${SPLUNK_FILENAME}.md5) \
    && tar xzf /tmp/${SPLUNK_FILENAME} --strip 1 -C ${SPLUNK_HOME} \
    && rm /tmp/${SPLUNK_FILENAME} \
    && rm /tmp/${SPLUNK_FILENAME}.md5 \
    && mkdir -p /var/opt/splunk \
    && cp -R ${SPLUNK_HOME}/etc ${SPLUNK_BACKUP_DEFAULT_ETC} \
    && rm -fR ${SPLUNK_HOME}/etc \
    && chown -R ${SPLUNK_USER}:${SPLUNK_GROUP} ${SPLUNK_HOME} \
    && chown -R ${SPLUNK_USER}:${SPLUNK_GROUP} ${SPLUNK_BACKUP_DEFAULT_ETC} \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

# Ports Splunk Daemon, Network Input, HTTP Event Collector
EXPOSE 8089/tcp 1514 8088/tcp

WORKDIR /opt/splunk

# Configurations folder, var folder for everyting (indexes, logs, kvstore)
VOLUME [ "/opt/splunk/etc", "/opt/splunk/var" ]

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["start-service"]
