FROM alpine

RUN apk update && apk add nginx
RUN rm -rf /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf

VOLUME "/var/www/localhost/htdocs/" 
VOLUME "/etc/nginx/conf.d/" 
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

EXPOSE 80 443
CMD ["/bin/entrypoint.sh"]
