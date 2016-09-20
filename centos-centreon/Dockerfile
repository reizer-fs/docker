FROM centos:centos6
MAINTAINER ffx <ffx@gmail.com>


ENV http_proxy=http://proxywebsrv.tech.sits.credit-agricole.fr:8080/
ENV https_proxy=http://proxywebsrv.tech.sits.credit-agricole.fr:8080/

ENV CENTREON_CONF="/etc/centreon/"
ENV CENTREON_WWW="/usr/share/centreon/www/"
ENV TERM=xterm

# Install Centreon Repository
RUN yum -y install http://yum.centreon.com/standard/3.0/stable/noarch/RPMS/ces-release-3.0-1.noarch.rpm
RUN yum -y update

# Install ssh
RUN yum -y install openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:centreon' | chpasswd
RUN sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
RUN /etc/init.d/sshd start && /etc/init.d/sshd stop

# Install centreon
RUN yum -y install centreon centreon-base-config-centreon-engine centreon-installed centreon-clapi

# Install Widgets
RUN yum -y install centreon-widget-graph-monitoring centreon-widget-host-monitoring centreon-widget-service-monitoring centreon-widget-hostgroup-monitoring centreon-widget-servicegroup-monitoring
# Fix pass in db
RUN  sed -i 's/^;date.timezone =.*$/date.timezone = Europe\/Paris/g' /etc/php.ini

# Set rights for setuid
RUN chown root:centreon-engine /usr/lib/nagios/plugins/check_icmp
RUN chmod -w /usr/lib/nagios/plugins/check_icmp
RUN chmod u+s /usr/lib/nagios/plugins/check_icmp

# Install and configure supervisor
RUN yum -y install python-setuptools nrpe-plugin
RUN easy_install supervisor

# Todo better split file
ADD supervisord.conf /etc/supervisord.conf
ADD run.sh /etc/centreon/
RUN ln -s /usr/lib64/nagios/plugins/check_nrpe /usr/lib/nagios/plugins/check_nrpe
RUN chmod +x /etc/centreon/run.sh
RUN rm -rf /var/tmp/* /tmp/*
RUN ln -s

# Expose port SSH and HTTP for the service
EXPOSE 22 80 443
VOLUME ["${CENTREON_CONF}"]
VOLUME ["${CENTREON_WWW}"]

CMD ["/usr/bin/supervisord","--configuration=/etc/supervisord.conf"]
