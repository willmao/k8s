#!/bin/bash

DOCKER_VERSION="17.03.2~ce-0~ubuntu-xenial"

HTTP_PROXY="http://192.168.0.102:7777"

echo "Acquire::http::proxy \"$HTTP_PROXY\";" > /etc/apt/apt.conf

apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get install -y docker-ce="$DOCKER_VERSION"

echo '' > /etc/apt/apt.conf

# groupadd docker

usermod -aG docker $USER

systemctl enable docker