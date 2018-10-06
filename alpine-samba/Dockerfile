FROM alpine

RUN apk update && apk add samba bash
RUN adduser -g 'Samba User' -h /tmp -D smbuser && \
    sed -i 's|^\(   log file = \).*|\1/dev/stdout|' /etc/samba/smb.conf && \
    sed -i 's|^\(   unix password sync = \).*|\1no|' /etc/samba/smb.conf && \
    sed -i '/Share Definitions/,$d' /etc/samba/smb.conf && \
    echo '   security = user' >>/etc/samba/smb.conf && \
    echo '   directory mask = 0775' >>/etc/samba/smb.conf && \
    echo '   force create mode = 0664' >>/etc/samba/smb.conf && \
    echo '   force directory mode = 0775' >>/etc/samba/smb.conf && \
    echo '   force user = smbuser' >>/etc/samba/smb.conf && \
    echo '   force group = users' >>/etc/samba/smb.conf && \
    echo '   load printers = no' >>/etc/samba/smb.conf && \
    echo '   lanman auth = yes' >>/etc/samba/smb.conf && \
    echo '   ntlm auth = yes' >>/etc/samba/smb.conf && \
    echo '   printing = bsd' >>/etc/samba/smb.conf && \
    echo '   printcap name = /dev/null' >>/etc/samba/smb.conf && \
    echo '   disable spoolss = yes' >>/etc/samba/smb.conf && \
    echo '   socket options = TCP_NODELAY' >>/etc/samba/smb.conf && \
    echo '' >>/etc/samba/smb.conf

RUN rm -rf /var/cache/apk/*
COPY samba.sh /usr/bin/
RUN chmod +x /usr/bin/samba.sh 
EXPOSE 137 139 445

ENTRYPOINT ["/usr/bin/samba.sh"]
