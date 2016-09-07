FROM suse-refreshed:latest

MAINTAINER Horus "horus@gmail.com"
ENV APACHE_VERSION=2.4.10 \
    TERM=xterm \
    APACHE_CONF=/etc/apache2/vhost.d \
    APACHE_DIR=/var/www \
    APACHE_LOG_DIR=/var/log/apache2/ \
    APACHE_USER=wwwrun \
    APACHE_GROUP=www \
    APACHE_MOUNT=/www

# make sure the repositories are up to date
RUN zypper in -y apache2 php5 php5-mysql apache2-mod_php5 php5-json php5-gd php5-dom php5-zlib php5-openssl php5-curl

COPY vhost.conf /etc/apache2/conf.d/vhost.conf
COPY entrypoint.sh /etc/entrypoint.sh
RUN mkdir $APACHE_MOUNT/
RUN ln -s $APACHE_MOUNT $APACHE_DIR
RUN chmod 755 /etc/entrypoint.sh
COPY .bash_profile /root/

EXPOSE 80/tcp
VOLUME ["${APACHE_DIR}"]
ENTRYPOINT ["/etc/entrypoint.sh"]
