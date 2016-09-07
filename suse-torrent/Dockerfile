FROM suse-refreshed:latest

MAINTAINER Horus "horus@gmail.com"
ENV TERM=xterm

RUN zypper in -y vim wget tar mlocate rtorrent

COPY rtorrent.rc /root/.rtorrent.rc

ENTRYPOINT ["/bin/bash"]
