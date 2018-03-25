FROM opensuse:42.2

MAINTAINER Horus "horus@gmail.com"
ENV http_proxy=http://proxy:8080/
ENV https_proxy=http://proxy:8080/
ENV TERM=xterm

RUN zypper in -y vim wget tar mlocate rtorrent
RUN zypper clean -a

COPY rtorrent.rc /root/.rtorrent.rc

ENTRYPOINT ["/bin/bash"]
