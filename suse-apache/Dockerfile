FROM opensuse:42.2

MAINTAINER Horus "horus@gmail.com"
ENV TERM=xterm

# make sure the repositories are up to date
RUN zypper ref -s && zypper in -y apache2 php5 php5-mysql apache2-mod_php5 php5-json php5-gd php5-dom php5-zlib php5-openssl php5-curl
RUN zypper clean -a

COPY vhost.conf /etc/apache2/conf.d/vhost.conf
COPY entrypoint.sh /etc/entrypoint.sh
RUN chmod 755 /etc/entrypoint.sh
RUN echo "LoadModule php5_module /usr/lib64/apache2/mod_php5.so" >> /etc/apache2/loadmodule.conf
RUN sed -i 's/^DirectoryIndex.*$/DirectoryIndex index.php index.html index.html.var/g' /etc/apache2/httpd.conf

EXPOSE 80/tcp
EXPOSE 443/tcp
ENTRYPOINT ["/etc/entrypoint.sh"]
