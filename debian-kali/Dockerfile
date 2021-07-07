FROM kalilinux/kali-linux-docker
MAINTAINER steev@kali.org


RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y realtek-rtl88xxau-dkms
RUN apt-get install -y hcxtools hcxdumptool
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean

CMD ["/bin/bash"]
