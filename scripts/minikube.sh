#!/bin/bash -e

declare HTTP_PROXY=192.168.0.102:7777
declare MINIKUBE_DOWNLOAD_URL=https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

if [ ! -f /usr/bin/kubectl ];then
    echo 'Try to get kubectl version number....'
    KUBECTL_VERSION=$(curl -x $HTTP_PROXY -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    echo "Latest stable version is $KUBECTL_VERSION"
    echo 'Download kubectl...'
    curl -x $HTTP_PROXY -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v.9.0/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/bin/
fi

if [ ! -f /usr/local/bin/minikube ];then
    echo 'Download minikube...'
    curl -Lo minikube http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v0.25.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
fi

export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
echo 'begin to start k8s...'
sudo -E minikube start --registry-mirror=https://registry.docker-cn.com --vm-driver=none