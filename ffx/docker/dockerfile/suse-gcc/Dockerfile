FROM opensuse-refreshed:latest

MAINTAINER Horus "horus@gmail.com"
ENV TERM=xterm
ENV http_proxy="http://10.211.55.21:3128"
ENV https_proxy="http://10.211.55.21:3128"

# make sure the repositories are up to date
RUN zypper in -y vim wget tar mlocate gcc make

COPY .bash_profile /root/
COPY entrypoint.sh /etc/entrypoint.sh

RUN chmod 755 /etc/entrypoint.sh
ENTRYPOINT ["/etc/entrypoint.sh"]
