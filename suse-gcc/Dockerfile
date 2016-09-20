FROM opensuse-refreshed:latest

MAINTAINER Horus "horus@gmail.com"
ENV TERM=xterm

# make sure the repositories are up to date
RUN zypper in -y vim wget tar mlocate gcc make
RUN zypper clean -a

COPY .bash_profile /root/
COPY entrypoint.sh /etc/entrypoint.sh

RUN chmod 755 /etc/entrypoint.sh
ENTRYPOINT ["/etc/entrypoint.sh"]
