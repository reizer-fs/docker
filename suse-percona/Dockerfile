FROM opensuse:42.2

EXPOSE 80 443

WORKDIR /opt

#ADD smt.crt /etc/pki/trust/anchors/smt.crt
#RUN update-ca-certificates

#RUN zypper --gpg-auto-import-keys ref -s




RUN zypper install -y curl git-core unzip python-requests tar fontconfig cron



RUN zypper addrepo --no-gpgcheck http://download.opensuse.org/repositories/devel:languages:python/SLE_12_SP1/devel:languages:python.repo
RUN zypper refresh
RUN zypper install -y supervisor

ADD nginx-1.10.2-1.sles12.ngx.x86_64.rpm /root/nginx.rpm
RUN zypper --no-gpg-checks --non-interactive install /root/nginx.rpm

ADD mysql57-community-release-sles12-8.noarch.rpm /root/mysql.rpm
RUN zypper --no-gpg-checks --non-interactive install /root/mysql.rpm
RUN zypper  --no-gpg-checks --non-interactive install mysql-community-server

RUN useradd -s /bin/false -U pmm
RUN useradd -U www-data
RUN mkdir /var/log/supervisor

# ########## #
# Prometheus #
# ########## #
RUN curl -s -LO https://github.com/prometheus/prometheus/releases/download/v1.2.2/prometheus-1.2.2.linux-amd64.tar.gz && \
        mkdir -p prometheus/data node_exporter && \
        chown -R pmm:pmm /opt/prometheus/data && \
        tar zxf prometheus-1.2.2.linux-amd64.tar.gz --strip-components=1 -C prometheus && \
        curl -s -LO https://github.com/prometheus/node_exporter/releases/download/0.12.0/node_exporter-0.12.0.linux-amd64.tar.gz && \
        tar zxf node_exporter-0.12.0.linux-amd64.tar.gz --strip-components=1 -C node_exporter && \
        rm -f prometheus-1.2.2.linux-amd64.tar.gz node_exporter-0.12.0.linux-amd64.tar.gz
COPY prometheus.yml /opt/prometheus/

# ###################### #
# Grafana and dashboards #
# ###################### #
COPY import-dashboards.py grafana-postinstall.sh VERSION /opt/
ADD grafana-3.1.1-1470047149.x86_64.rpm /root/grafana.rpm
RUN rpm -i --nodeps /root/grafana.rpm

RUN git clone https://github.com/percona/grafana-dashboards.git 

RUN cp /opt/VERSION /var/lib/grafana/ && \
    rm -rf /root/grafana.rpm grafana-dashboards/.git

RUN  /opt/grafana-postinstall.sh

# ###### #
# Consul #
# ###### #
RUN curl -s -LO https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip && \
        unzip consul_0.7.0_linux_amd64.zip && \
        mkdir -p /opt/consul-data && \
        chown -R pmm:pmm /opt/consul-data && \
        rm -f consul_0.7.0_linux_amd64.zip

# ##### #
# Nginx #
# ##### #
COPY nginx.conf nginx-ssl.conf /etc/nginx/
RUN touch /etc/nginx/.htpasswd

# ############ #
# Orchestrator #
# ############ #
COPY orchestrator.conf.json /etc/

ADD orchestrator-1.5.6-1.x86_64.rpm /root/orchestrator.rpm
RUN zypper --no-gpg-checks --non-interactive install /root/orchestrator.rpm


RUN curl -s -LO https://www.percona.com/downloads/TESTING/pmm/orchestrator-1.5.6-patch.tgz && \
    tar zxf orchestrator-1.5.6-patch.tgz -C /usr/local/orchestrator/ && \
    rm -f orchestrator-1.5.6-patch.tgz

RUN rm -f /root/orchestrator.rpm

# ########################### #
# Supervisor and landing page #
# ########################### #
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY entrypoint.sh /opt
COPY landing-page/ /opt/landing-page/

# ####################### #
# Percona Query Analytics #
# ####################### #
COPY purge-qan-data /etc/cron.daily/
COPY qan-install.sh /opt/
ADD https://www.percona.com/downloads/TESTING/pmm/percona-qan-api-1.0.6-20161024.2cbdd01-x86_64.tar.gz \
    https://www.percona.com/downloads/TESTING/pmm/percona-qan-app-1.0.6.tar.gz \
    /opt/

RUN curl -s -L -o /usr/bin/pt-archiver https://raw.githubusercontent.com/percona/percona-toolkit/2.2/bin/pt-archiver && \
        chmod 755 /usr/bin/pt-archiver && \
        mkdir qan-api qan-app && \
        tar zxf percona-qan-api-1.0.6-20161024.2cbdd01-x86_64.tar.gz --strip-components=1 -C qan-api && \
        tar zxf percona-qan-app-1.0.6.tar.gz --strip-components=1 -C qan-app 

RUN /opt/qan-install.sh
RUN rm -rf percona-qan-api-1.0.6-20161024.2cbdd01-x86_64.tar.gz percona-qan-app-1.0.6.tar.gz qan-api

# ####### #
# Volumes #
# ####### #

VOLUME /opt/prometheus/data
VOLUME /opt/consul-data
VOLUME /var/lib/mysql

# ##### #
# Start #
# ##### #
CMD ["/opt/entrypoint.sh"]
