FROM docker.io/ubuntu:16.04

ENV HTTP_PROXY="http://192.168.0.102:7777/"

RUN apt-get update && apt-get install -y apt-transport-https curl

RUN curl -x ${HTTP_PROXY} -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list

RUN export http_proxy=${HTTP_PROXY} && apt-get update && apt-get install -y kubelet

RUN sed -i 57,58d /var/lib/dpkg/info/kubelet.postinst

RUN export http_proxy=${HTTP_PROXY} && apt-get update && apt-get install -y kubeadm kubectl