FROM alpine

RUN apk update && apk add php5-cli php5-fpm php5-mysql
RUN apk add php5-fpm php5-json php5-zlib php5-xml php5-pdo php5-phar php5-openssl php5-pdo_mysql php5-mysqli php5-gd php5-iconv php5-mcrypt php5-curl php5-opcache php5-ctype php5-apcu php5-intl php5-bcmath php5-dom php5-xmlreader

RUN rm -rf /var/cache/apk/*

RUN sed -i 's/^listen =.*$/listen = 0\.0\.0\.0:9000/g' /etc/php5/php-fpm.conf
EXPOSE 9000

CMD ["php-fpm5", "-F"]
