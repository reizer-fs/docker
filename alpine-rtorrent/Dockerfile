FROM alpine
  
ENV TERM=xterm
RUN apk update && apk add rtorrent
RUN rm -rf /var/cache/apk/*
RUN mkdir -p /var/data/

COPY rtorrent.rc /root/.rtorrent.rc

ENTRYPOINT ["sh"]
