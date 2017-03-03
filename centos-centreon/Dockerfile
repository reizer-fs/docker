FROM centos:centos6
MAINTAINER ffx <ffx@gmail.com>


#ENV http_proxy=http://proxywebsrv.tech.sits.credit-agricole.fr:8080/
#ENV https_proxy=http://proxywebsrv.tech.sits.credit-agricole.fr:8080/

ENV CENTREON_CONF="/etc/centreon/"
ENV CENTREON_WWW="/usr/share/centreon/www/"
ENV TERM=xterm


# Install Centreon Repository

RUN yum -y install wget
RUN wget http://yum-1.centreon.com/standard/3.4/el6/stable/RPM-GPG-KEY-CES -O /etc/pki/rpm-gpg/RPM-GPG-KEY-CES
RUN wget http://yum.centreon.com/standard/3.4/el6/stable/centreon-stable.repo -O /etc/yum.repos.d/centreon-stable.repo

RUN yum -y update
RUN yum -y install centreon-base-config-centreon-engine centreon


# Install ssh
RUN yum -y install openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:centreon' | chpasswd
RUN sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
RUN /etc/init.d/sshd start && /etc/init.d/sshd stop

RUN yum -y install centreon-widget-graph-monitoring centreon-widget-host-monitoring centreon-widget-service-monitoring centreon-widget-hostgroup-monitoring centreon-widget-servicegroup-monitoring
# Fix pass in db
RUN  sed -i 's/^;date.timezone =.*$/date.timezone = Europe\/Paris/g' /etc/php.ini
RUN echo "SELINUX=disabled" > /etc/sysconfig/selinux

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

# Expose port SSH and HTTP for the service
EXPOSE 22 80 443
VOLUME ["${CENTREON_CONF}"]
VOLUME ["${CENTREON_WWW}"]

CMD ["/usr/bin/supervisord","--configuration=/etc/supervisord.conf"]
