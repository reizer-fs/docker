
FROM alpine

RUN apk add --no-cache curl sudo
RUN curl https://my-netdata.io/kickstart-static64.sh >/tmp/kickstart-static64.sh
RUN yes | sh /tmp/kickstart-static64.sh

ENV NETDATA_PORT=19999 SSMTP_TLS=YES SSMTP_SERVER=smtp.gmail.com SSMTP_PORT=587 SSMTP_HOSTNAME=localhost
EXPOSE $NETDATA_PORT
CMD "/opt/netdata/bin/srv/netdata"
