DIRECTORY="$HOME"
SHARES="Downloads Git Documents"
IP_VHOST="10.11.66.1 10.11.12.1"
DOCKER_CMD="podman"
DOCKER_ARGS="--cpus=1 -m 1g"
DOCKER_IMG_NAME="alpine-samba"
DOCKER_CNT_NAME="--name alpine-samba"
DOCKER_CMD_ARGS="-n -u ffx;badpass"

# Allow users to bind on low ports
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=0 &>/dev/null

# Allow samba port on firewalld
sudo firewall-cmd --add-service=samba --permanent

# Allow users to limit cpu in systemd configuration (rootless)
if [ ! -f "/etc/systemd/system/user\@.service.d/delegate.conf" ] ; then
    sudo mkdir /etc/systemd/system/user\@.service.d &>/dev/null
    cat << EOF | sudo tee /etc/systemd/system/user\@.service.d/delegate.conf &>/dev/null
[Service]
Delegate=memory pids cpu io
EOF
sudo systemctl daemon-reload
fi

# Bind port on multiple interface
for IP in ${IP_VHOST} ; do
    DOCKER_PORTS_BIND="${DOCKER_PORTS_BIND} -p ${IP}:137:137 -p ${IP}:139:139 -p ${IP}:445:445"
done

# Create local shares if not present
for SHARE in ${SHARES} ; do
    if [ ! -d "${DIRECTORY}/${SHARE}" ] ; then
	mkdir -p ${DIRECTORY}/${SHARE}
    fi
    DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DIRECTORY}/${SHARE}:/shares/${SHARE}"
    DOCKER_CMD_ARGS="${DOCKER_CMD_ARGS} -s ${SHARE};/shares/${SHARE};yes;no;yes;;ffx"
done

CMD="${DOCKER_CMD} run --rm -it -d --hostname ${DOCKER_IMG_NAME} \
${DOCKER_ARGS} \
${DOCKER_CNT_NAME} \
${DOCKER_PORTS_BIND} \
${DOCKER_VOLUMES} \
${DOCKER_IMG_NAME} \
${DOCKER_CMD_ARGS}"

$CMD
