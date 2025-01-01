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

    if [ -z "$DNS" ]; then
        # 如果未设置 DNS，生成不包含 DNS 的配置
        cat > /etc/snell-server.conf <<EOF
[snell-server]
listen=::0:$PORT
psk=$PSK
ipv6=$IPV6
EOF
    else
        # 如果设置了 DNS，生成包含 DNS 的配置
        cat > /etc/snell-server.conf <<EOF
[snell-server]
listen=::0:$PORT
psk=$PSK
ipv6=$IPV6
dns=$DNS
EOF
    fi
}

if [ -f "${CONF}" ]; then
    # 配置文件存在，直接使用
    echo "Using existing configuration file: ${CONF}"
    ${BIN} -c ${CONF}
else
    # 配置文件不存在，生成配置
    echo "Configuration file not found, generating a new one."
    generate_config
    echo -e "\033[32m$(cat ${CONF})\033[0m"
    ${BIN} -c ${CONF}
fi

