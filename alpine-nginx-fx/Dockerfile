FROM alpine:latest

RUN apk update && apk add bash nginx
RUN rm -rf /var/cache/apk/*


RUN mkdir /etc/nginx/global/
COPY default.conf /etc/nginx/conf.d/default.conf
COPY wordpress.conf /etc/nginx/global/wordpress.conf
COPY restrictions.conf /etc/nginx/global/restrictions.conf
COPY proxy.conf /etc/nginx/global/proxy.conf
COPY docker-entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
RUN mkdir /var/www/html/

VOLUME "/var/www/html/" 
VOLUME "/etc/nginx/global/" 

WORKDIR "/var/www/html/"
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
