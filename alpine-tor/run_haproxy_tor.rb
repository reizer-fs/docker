#!/usr/bin/env ruby
require_relative 'proxy_setup.rb'
include ProxySetupModule

proxy = ProxySetupModule::ProxySetup.new(haproxy_cfg_erb:                       ENV.fetch('haproxy_cfg_erb','haproxy.cfg.erb'),
                                         haproxy_port:                          ENV.fetch('haproxy_port',10000).to_i,
                                         haproxy_stat_port:                     ENV.fetch('haproxy_stat_port',10100).to_i,
                                         number_of_tors:                        ENV.fetch('number_of_tors',10).to_i,
                                         torrc_erb:                             ENV.fetch('torrc_cfg_erb','torrc.cfg.erb'),
                                         starting_tor_http_tunnel_port:         ENV.fetch('starting_tor_http_tunnel_port',15000).to_i,
                                         tor_exit_node:                         ENV.fetch('tor_exit_node','us'),
                                         username:                              ENV.fetch('username','username'),
                                         password:                              ENV.fetch('password','password'))

Signal.trap("TERM") { proxy.kill_processes }
Signal.trap("INT")  { proxy.kill_processes }

proxy.cleanup
proxy.create_configs
proxy.run
proxy.wait_for_haproxy

at_exit do
  puts "Starting at exit"
  proxy.kill_processes
end
