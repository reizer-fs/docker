PROJECT="alpha3"
DIRECTORY="$HOME/Projects/Django"
SHARES="${PROJECT}"
IP_VHOST="10.11.66.1 10.11.12.1 192.168.0.43"
DOCKER_CMD="podman"
DOCKER_PORTS="83"
DOCKER_ARGS="--cpus=1 -m 1g"
DOCKER_IMG_NAME="django-template"
DOCKER_CNT_NAME="--name django-${PROJECT}"
DOCKER_CMD_ARGS=""

# Allow users to bind on low ports
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=0 &>/dev/null

# Allow samba port on firewalld
sudo firewall-cmd --add-service=http --permanent &>/dev/null
sudo systemctl restart firewalld &>/dev/null

# Allow users to limit cpu in systemd configuration (rootless)
if [ ! -f "/etc/systemd/system/user\@.service.d/delegate.conf" ] ; then
    sudo mkdir /etc/systemd/system/user\@.service.d &>/dev/null
    cat << EOF | sudo tee /etc/systemd/system/user\@.service.d/delegate.conf &>/dev/null
[Service]
Delegate=memory pids cpu io
EOF
sudo systemctl daemon-reload &>/dev/null
fi

# Bind port on multiple interface
for IP in ${IP_VHOST} ; do
    DOCKER_PORTS_BIND="${DOCKER_PORTS_BIND} -p ${IP}:${DOCKER_PORTS}:8000"
done

# Create local shares if not present
for SHARE in ${SHARES} ; do
    if [ ! -d "${DIRECTORY}/${SHARE}" ] ; then
	mkdir -p ${DIRECTORY}/${SHARE}
    fi
    DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DIRECTORY}/${SHARE}:/code:Z"
done

CMD="${DOCKER_CMD} run --rm -it -d --hostname ${DOCKER_IMG_NAME} \
${DOCKER_ARGS} \
${DOCKER_CNT_NAME} \
${DOCKER_PORTS_BIND} \
${DOCKER_VOLUMES} \
${DOCKER_IMG_NAME} \
${DOCKER_CMD_ARGS}"

$CMD
