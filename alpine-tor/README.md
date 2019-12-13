haproxy-tor
-----------

```
               Docker Container
               -------------------------------------
                        <-> Tor HTTPTunnelPort 1
Client <---->  HAproxy  <-> Tor HTTPTunnelPort 2
                        <-> Tor HTTPTunnelPort .
                        <-> Tor HTTPTunnelPort .
                        <-> Tor HTTPTunnelPort .
                        <-> Tor HTTPTunnelPort n
```


How:
---
A single Ruby script to create all the needed config files (for tor, HAProxy).<br>
Unlike the parents repos, there is no periodic killing and restarting of the clients.<br>
The Ruby script is used mainly to make the setup easy to control,<br>
since there is no real need for extra external software for this setup.<br>


Changing Tor settings is done by changing the reference `torrc.cfg.erb` file.<br>
If a change isn't consistent across all `torrc` files, `proxy_setup.rb` should be enhanced.<br>


Usage:
------
```
# Build the container
docker build -t 'haproxy-tor' .
# Run the container shell for manual testing:
docker run -it haprox-tor:latest /bin/bash
# Log into a running container 
docker exec -i -t <container_id> /bin/bash
# Running with default and minimal inputs:
docker run -d -p 10000:10000 -p 10100:10100 -p 15000:15000 haprox-tor:latest
# Changing the ports, external and internal:
docker run -d -p 20000:20000 -p 20100:20100 -p 25000:25000 -e number_of_tors=15 -e haproxy_port=20000 -e haproxy_stat_port=20100 -e starting_tor_http_tunnel_port=25000 haprox_tor:latest
# Changing the ports, internal only:
docker run -d -p 10000:20000 -p 10100:20100 -p 15000:25000 -e number_of_tors=15 -e haproxy_port=20000 -e haproxy_stat_port=20100 -e starting_tor_http_tunnel_port=25000 haprox_tor:latest

```


Environment Variables
---------------------
 * `haproxy_cfg_erb` - Path to the location of the HAProxy config file (Default: `/haproxy_tor/run_area/haproxy.cfg.erb`)
 * `haproxy_port` - The port HAProxy client listen on (Default: 10000).
 * `haproxy_stat_port` - The port HAProxy stats will listen on (Default: 10100).
 * `number_of_tors` - The number of tor clients (Default: 10).
   seconds. (Default: 60 seconds)
 * `torrc_cfg_erb` - Path to the location of the torrc config file (Default: `/haproxy_tor/run_area/torrc.cfg.erb`)
 * `starting_tor_http_tunnel_port` - The starting port for HTTPTunnelPort (Default: 15000).
 * `tor_exit_node` - Tor ExitNode (Default: us). 
 * `username` - HAProxy stats username (Default: username). 
 * `password` - HAProxy stats password (Default: password).
 

Further Readings
----------------

 * [Tor Manual](https://www.torproject.org/docs/tor-manual.html.en)
 * [HAProxy Manual](https://cbonte.github.io/haproxy-dconv/1.7/configuration.html)
