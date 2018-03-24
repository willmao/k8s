#!/bin/bash -e

HTTP_PROXY="http://192.168.0.102:7777/"

export http_proxy=${HTTP_PROXY}

K8S_VERSION=1.9.3

function usage() {
    echo 'tool to help start k8s with kubeadm'
    echo 'usage: ./k8s.sh [options]'
    echo 'options:'
    echo 'install   install kubeadm kubectl kubelet, need to be run as root'
    echo 'init      init k8s master node'
}

function install_k8s() {
    apt-get update && apt-get install -y apt-transport-https
    curl -x ${HTTP_PROXY} -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
    apt-get update && apt-get install -y kubelet kubeadm kubectl
}

function swap_off() {
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
    ## systemctl mask dev-sdXX.swap maybe needed to swapoff after reboot
}

function init() {
    kubeadm init --kubernetes-version "v$K8S_VERSION"
}

function config() {
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

case "$1" in
    install)
        install_k8s
    ;;
    init)
        swap_off
        init
    ;;
    config)
        config
    ;;
    *)
        usage
    ;;
esac