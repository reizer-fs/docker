FROM alpine

ENV GRAFANA_VERSION=8.3.6
RUN apk --no-cache add openssl wget

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_USER="grafana" \
    GF_GROUP="grafana" \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

RUN mkdir /tmp/grafana ${GF_PATHS_HOME} \
  && wget -q -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
  && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C ${GF_PATHS_HOME} \
  && rm /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz


RUN mkdir -p "$GF_PATHS_HOME"
WORKDIR $GF_PATHS_HOME    

RUN set -ex \
    && addgroup -S $GF_GROUP \
    && adduser -S -G $GF_GROUP $GF_USER \
    && apk add --no-cache libc6-compat ca-certificates su-exec bash

COPY ./config/grafana.ini "$GF_PATHS_CONFIG"
COPY ./run.sh /run.sh

EXPOSE 3000

CMD ["/run.sh"]
