#!/bin/bash -e

HTTP_PROXY="http://192.168.0.102:7777/"

export http_proxy=${HTTP_PROXY}

function install_k8s() {
    apt-get update && apt-get install -y apt-transport-https
    curl -x ${HTTP_PROXY} -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
    apt-get update && apt-get install -y kubelet kubeadm kubectl
}

usage=$(cat <<EOF
Tools to init k8s with kubeadm
Usage: k8s.sh option
install         install kubeadm tools
EOF
)

case "$1" in
    install)
        install_k8s
    ;;
    *)
        echo "$usage"
    ;;
esac