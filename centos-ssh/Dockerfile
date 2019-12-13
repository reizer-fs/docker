FROM centos:8
MAINTAINER ffx <ffx@gmail.com>


ENV TERM=xterm
ENV NOTVISIBLE "in users profile"
RUN yum -y update && yum -y install openssh-server
RUN /usr/bin/ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile
RUN sed -i 's/^#Port.*$/Port 77/g' /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 77
