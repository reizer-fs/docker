FROM opensuse:42.2

MAINTAINER Horus "horus@gmail.com"
ENV http_proxy=http://proxy:8080/
ENV https_proxy=http://proxy:8080/
ENV APACHE_VERSION=2.4.10 \
    TERM=xterm

# make sure the repositories are up to date
RUN zypper -n install wget apache2 openssl openssl-devel perl perl-Net-SSLeay perl-Crypt-SSLeay

RUN cd /tmp/ && wget -q https://sourceforge.net/projects/webadmin/files/webmin/1.810/webmin-1.810-1.noarch.rpm
RUN cd /tmp/ && rpm -ivh webmin-1.810-1.noarch.rpm
RUN rm -rf /tmp/webmin-1.810-1.noarch.rpm && rm -rf /tmp/webmin*
RUN zypper clean -a

EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 10000/tcp
ENTRYPOINT ["/bin/bash"]
