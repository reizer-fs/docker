FROM opensuse:42.2

MAINTAINER Horus "horus@gmail.com"
ENV http_proxy=http://proxy:8080/
ENV https_proxy=http://proxy:8080/
RUN zypper in -y proftpd


ADD proftpd.conf /etc/proftpd/proftpd.conf
ADD entrypoint.sh /usr/bin/
RUN chown root:root /etc/proftpd/proftpd.conf
RUN chmod +x /usr/bin/entrypoint.sh
RUN mkdir /ftp

EXPOSE 21
EXPOSE 20


ENTRYPOINT ["/usr/bin/entrypoint.sh"]
