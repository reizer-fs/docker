
export PS1="\[$(tput bold)\]\[$(tput setaf 0)\]\t \[$(tput setaf 0)\][\[$(tput setaf 1)\]\u\[$(tput setaf 1)\]@\[$(tput setaf 1)\]\h \[$(tput setaf 1)\]\W\[$(tput setaf 0)\]]\[$(tput setaf 0)\]\\$ \[$(tput sgr0)\]"


# Global alias
alias cdscript='cd /opt/ffx/scripts'
alias cdplugins='cd /usr/lib/nagios/plugins/'
#### Alias Sesction ####
alias proxy="export http_proxy=http://sfx2:3128"
alias ll='ls -l'
alias la='ls -ltra'

alias h='history'
alias j='jobs -l'

## Editor ###
alias vi=vim
alias vis='vim "+set si"'
alias edit='vim'


alias fastping='ping -c 100 -s.2'
 
# get web server headers #
alias header='curl -I'
 
# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'



alias tcpdump='tcpdump -i'

case `uname -s` in
	Linux)

	# display all rules #
	## Colorize the grep command output for ease of use (good for log files)##
	alias grep='grep --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
	alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
	alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
	alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
	alias firewall=iptlist
	alias ports='netstat -tulanp'
	alias ipt='sudo /sbin/iptables'
	alias mkdir='mkdir -pv'
	
	#Service management
	alias reload='systemctl reload'
	alias restart='systemctl restart'
	alias restart='systemctl restart'
	alias start='systemctl start'
	alias stop='systemctl stop'

	alias mnt='mount |column -t'
	alias zr='zypper ref -s'
	alias zi='zypper in'
	alias zs='zypper se'
	## pass options to free ## 
	alias meminfo='free -m -l -t'
	 
	## get top process eating memory
	alias psmem='ps auxf | sort -nr -k 4 | head -20'

	## get top process eating cpu ##
	alias pscpu='ps auxf | sort -nr -k 3 | head -20'
	alias ping='ping -c 5'
	# Docker
	alias cddocker='cd /opt/ffx/docker/dockerfile'
	alias dp='docker ps -a'
	alias di='docker images'
	alias dri='docker rmi'
	alias dr='docker rm'
	alias dkd="docker run -d -P"
	alias dki="docker run -t -i -P"
	function docker-clean() {
		docker rmi -f $(docker images -q -a -f dangling=true)
	}
	function db (){ 
		docker build -t="$1" .; 
	}
	function dsh () {
		docker exec -i -t $1 /bin/bash
	}
	function dbash () {
		docker run --rm -i -t -e TERM=xterm --entrypoint /bin/bash $1
	}
	;;
	SunOS*) 
	alias ifconfig="ifconfig -a | egrep -v 'IPv6|inet6'"
	alias pgrep='ps -ef | grep -i'
	alias tailf='tail -f'
	alias mkdir='mkdir -p'
	
	alive () {
	ping -s $1 2 4
	}
	;;
esac
