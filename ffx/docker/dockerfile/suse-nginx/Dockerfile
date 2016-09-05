FROM opensuse-refreshed:latest

MAINTAINER Horus "horus@gmail.com"

# make sure the repositories are up to date
#RUN cd /tmp/ && wget http://download.opensuse.org/repositories/home:/stargieg:/branches:/home:/microchip8/openSUSE_13.2/x86_64/nginx-1.7.7-13.1.x86_64.rpm
#RUN rpm -ivh /tmp/nginx-1.7.7-13.1.x86_64.rpm
#RUN systemctl enable nginx
RUN zypper ar http://download.opensuse.org/repositories/home:/microchip8/openSUSE_Factory/ "Micro Chip 8"
RUN zypper --no-gpg-checks install -y nginx



#echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
#chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
