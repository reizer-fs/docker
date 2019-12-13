module ProxySetupModule
  require 'erb'
  require 'fileutils'
  require 'socket'
  require 'timeout'
  class ProxySetup
    attr_accessor :haproxy_cfg_erb, :haproxy_port, :haproxy_stat_port, :number_of_tors, :torrc_erb, :starting_tor_http_tunnel_port, :tor_exit_node, :pids,
                  :pwd, :username, :password
    ############################################################################################################################################
    def initialize(haproxy_cfg_erb: 'haproxy.cfg.erb', haproxy_port:, haproxy_stat_port:,
                   torrc_erb: 'erb_torrc.erb', starting_tor_http_tunnel_port:,
                   tor_exit_node:, number_of_tors:, username: ,password:)
      @haproxy_cfg_erb    = haproxy_cfg_erb
      @haproxy_port       = haproxy_port
      @haproxy_stat_port  = haproxy_stat_port
      @number_of_tors     = number_of_tors
      @torrc_erb          = torrc_erb
      @starting_tor_http_tunnel_port = starting_tor_http_tunnel_port
      @tor_exit_node      = tor_exit_node
      @username           = username
      @password           = password
      @pids               = []
      @output_haproxy     = File.absolute_path("#{@tor_exit_node}/haproxy.cfg_haproxy_port_#{@haproxy_port}_haproxy_stat_port_#{@haproxy_stat_port}_starting_tor_http_tunnel_port_#{@starting_tor_http_tunnel_port}_tor_exit_node_#{@tor_exit_node}_number_of_tors_#{@number_of_tors}")
      @ready_to_run       = false
      @pwd                = Dir.pwd
    end
    ############################################################################################################################################
    def wait_for_haproxy
      puts "#{__method__} Waiting for haproxy #{@haproxy_pid}"
      Process.waitpid(@haproxy_pid)
    rescue Errno::ESRCH, Errno::ECHILD => e
      puts "#{__method__} => #{e.message}"
    ensure
      kill_processes
    end
    ############################################################################################################################################
    def kill_processes(signal='SIGKILL')
      while pid = @pids.pop
        begin
          puts "#{__method__} Killing #{pid}"
          Process.kill(signal, pid)
          Process.wait
        rescue Errno::ESRCH, Errno::ECHILD => e
          puts "#{__method__} Process #{pid} => #{e.message}"
        end
      end
    end
    ############################################################################################################################################
    def run
      unless @ready_to_run
        puts "#{__method__} Not ready to run"
        return
      end
      @pwd = Dir.pwd
      Dir.chdir(@tor_exit_node_dir)
      Dir.glob("#{@lib_torrc}/*").each do |torrc|
        pid = Process.fork
        @pids << pid
        if pid.nil?
          # In child
          command = "tor -f #{torrc} &> #{@tor_logs}/#{File.basename(torrc)}.log"
          puts "#{__method__} executing => #{command}"
          exec(command)
        else
          # In parent
          #Process.detach(pid)
        end
      end

      pid = Process.fork
      @pids << pid
      if pid.nil?
        # In child
        command = "haproxy -f #{@output_haproxy}"
        puts "#{__method__} executing => #{command}"
        exec(command)
      else
        @haproxy_pid = pid
      end
      Dir.chdir(@pwd)
    end
    ############################################################################################################################################
    def create_configs
      cleanup
      unless check_inputs
        puts "#{__method__} issues with inputs"
        return
      end
      unless write_haproxy_config
        puts "#{__method__} issues writing haproxy config"
        return
      end
    end
    ############################################################################################################################################
    def check_inputs
      return false unless ProxySetup.check_type(@haproxy_cfg_erb, String)
      return false unless ProxySetup.check_type(@haproxy_port, Integer)
      return false unless ProxySetup.check_type(@haproxy_stat_port, Integer)
      return false unless ProxySetup.check_type(@number_of_tors, Integer)
      return false unless ProxySetup.check_type(@torrc_erb, String)
      return false unless ProxySetup.check_type(@starting_tor_http_tunnel_port, Integer)
      return false unless ProxySetup.check_type(@tor_exit_node, String)
      return false unless ProxySetup.check_file(@haproxy_cfg_erb)
      return false unless ProxySetup.check_file(@torrc_erb)
      [@haproxy_port, @haproxy_stat_port].each do |port|
        unless ProxySetup.port_available?(port: port)
          puts "#{__method__} Port #{port} isn't available"
          return false
        end
      end
      return true
    end
    ############################################################################################################################################
    def cleanup
      @tor_exit_node_dir = ProxySetup.prep_dir("#{@tor_exit_node}/")
      @lib_torrc    = ProxySetup.prep_dir("#{@tor_exit_node}/lib_torrc")
      @tor_logs     = ProxySetup.prep_dir("#{@tor_exit_node}/tor_logs")
      @tor_data_dir = ProxySetup.prep_dir("#{@tor_exit_node}/tor_data")
      @tor_pids     = ProxySetup.prep_dir("#{@tor_exit_node}/tor_pids")
      return true
    end
    ############################################################################################################################################
    def write_haproxy_config
      @backends = []
      @number_of_tors.times do |i|
        tor_http_tunnel_port = i + @starting_tor_http_tunnel_port
        tor_socks_port       = tor_http_tunnel_port + 10000
        [tor_http_tunnel_port, tor_socks_port].each do |port|
          unless ProxySetup.port_available?(port: port)
            puts "#{__method__} Port #{port} isn't available"
            return false
          end
        end
        @backends << {
            name: "tor_server_#{tor_http_tunnel_port}",
            port: tor_http_tunnel_port,
            addr: '127.0.0.1'
        }
        output_torrc         = File.absolute_path("#{@lib_torrc}/torrc.#{tor_http_tunnel_port}")
        data_dir             = File.absolute_path("#{@tor_data_dir}/http_#{tor_http_tunnel_port}_socks_#{tor_socks_port}")
        tor_log_file         = File.absolute_path("#{@tor_logs}/http_#{tor_http_tunnel_port}_socks_#{tor_socks_port}")
        tor_pid_file         = File.absolute_path("#{@tor_pids}/http_#{tor_http_tunnel_port}_socks_#{tor_socks_port}")
        ProxySetup.prep_dir(data_dir)
        File.write(output_torrc, ERB.new(File.read(@torrc_erb)).result(binding))
      end
      File.write(@output_haproxy, ERB.new(File.read(@haproxy_cfg_erb)).result(binding))
      @ready_to_run = true
      return true
    end
    ############################################################################################################################################
    ############################################################################################################################################
    ############################################################################################################################################
    def self.check_file(file_name)
      if !File.exist?(file_name)
        puts "#{__method__} File missing #{file_name}"
        return false
      elsif !File.readable?(file_name)
        puts "#{__method__} File not readable #{file_name}"
        return false
      else
        return true
      end
    end
    ############################################################################################################################################
    def self.prep_dir(dir_name)
      FileUtils::mkdir_p(dir_name)
      FileUtils::rm_rf(Dir.glob("#{dir_name}/*"))
      return File.absolute_path(dir_name)
    end
    ############################################################################################################################################
    def self.check_type(input, type)
      unless input.is_a?(type)
        puts "#{__method__} Expected '#{input}' to be '#{type}' , but it's '#{input.class.name}'"
        return false
      end
      return true
    end
    ############################################################################################################################################
    def self.port_available?(ip: '127.0.0.1', port:, seconds: 1)
      Timeout::timeout(seconds) do
        begin
          TCPSocket.new(ip, port).close
          false
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          true
        end
      end
    rescue Timeout::Error
      true
    end
    ############################################################################################################################################
  end
end
