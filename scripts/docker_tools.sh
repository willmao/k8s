#!/bin/bash

function set_proxy() {
    HTTP_PROXY=$1
    [ -e $1 ] && echo 'proxy url needed' && exit -1
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf

    cat << EOF | sudo tee 1>/dev/null /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=$HTTP_PROXY" "NO_PROXY=localhost,127.0.0.1"
EOF
    cat << EOF | sudo tee 1>/dev/null /etc/systemd/system/docker.service.d/https-proxy.conf
[Service]
Environment="HTTPS_PROXY=$HTTP_PROXY" "NO_PROXY=localhost,127.0.0.1"
EOF
}

function unset_proxy() {
    sudo rm -rf /etc/systemd/system/docker.service.d/http-proxy*.conf
}

function usage() {
    echo 'tools to set http proxy for docker'
    echo 'usage: ./docker_tools.sh [options]'
    echo './docker_tools.sh set proxy_url'
    echo './docker_tools.sh unset'
}

case "$1" in
    set)
        set_proxy $2
    ;;
    unset)
        unset_proxy
    ;;
    *)
        usage
    ;;
esac