FROM alpine

RUN apk update && apk add mariadb mariadb-client
RUN addgroup mysql mysql && rm -rf /var/cache/apk/*

COPY ./startup.sh /bin/startup.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306
RUN chmod +x /bin/startup.sh

CMD ["/bin/startup.sh"]
