FROM opensuse:42.2

MAINTAINER Horus "horus@gmail.com"

# make sure the repositories are up to date
RUN zypper ref -s
RUN zypper in -y mariadb
RUN zypper in -y pwgen
RUN zypper clean -a
RUN rm -rf /var/lib/mysql/*

# Add MySQL configuration
ADD create_mariadb_admin_user.sh /etc/create_mariadb_admin_user.sh
ADD entrypoint.sh /etc/entrypoint.sh
RUN echo "cat /etc/hostname" > /usr/bin/hostname
RUN chmod 775 /usr/bin/hostname /etc/entrypoint.sh /etc/create_mariadb_admin_user.sh

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

#Added to avoid in container connection to the database with mysql client error message "TERM environment variable not set"
ENV TERM xterm

EXPOSE 3306
CMD ["/etc/entrypoint.sh"]
