#!/bin/bash
set -e

BIN="/usr/local/bin/snell-server"
CONF="/etc/snell-server.conf"

random_port() {
    shuf -i 1024-65535 -n 1
}

random_psk() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1
}

generate_config() {
    PORT=${PORT:-$(random_port)}
    PSK=${PSK:-$(random_psk)}
    IPV6=${IPV6:-true}
    DNS=${DNS:-1.1.1.1}
    cat > /etc/snell-server.conf <<EOF
[snell-server]
listen=0.0.0.0:$PORT
psk=$PSK
ipv6=$IPV6
dns=$DNS
EOF
}

generate_config
echo -e "\033[32m$(cat ${CONF})\033[0m"

${BIN} -c ${CONF}

