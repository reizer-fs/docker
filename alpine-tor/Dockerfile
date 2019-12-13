FROM alpine:latest
LABEL 'label'='haproxy_tor'

ENV TOR_DIR="/haproxy_tor"
RUN apk update
RUN apk upgrade
RUN apk add \
    haproxy ruby shadow bash-completion tor \
    ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler ruby-dev \
    --update \
    --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main

CMD mkdir -p            $TOR_DIR/run_area/
ADD haproxy.cfg.erb     $TOR_DIR/run_area/haproxy.cfg.erb
ADD proxy_setup.rb      $TOR_DIR/run_area/proxy_setup.rb
ADD torrc.cfg.erb       $TOR_DIR/run_area/torrc.cfg.erb
ADD run_haproxy_tor.rb  $TOR_DIR/run_area/run_haproxy_tor.rb
RUN chmod +x            $TOR_DIR/run_area/run_haproxy_tor.rb

ENV haproxy_cfg_erb=$TOR_DIR/run_area/haproxy.cfg.erb
ENV haproxy_port=10000
ENV haproxy_stat_port=10100
ENV number_of_tors=10
ENV torrc_cfg_erb=$TOR_DIR/run_area/torrc.cfg.erb
ENV starting_tor_http_tunnel_port=15000
ENV tor_exit_node=us
ENV username=username
ENV password=password

CMD ruby /haproxy_tor/run_area/run_haproxy_tor.rb

EXPOSE 10000 10100 15000
