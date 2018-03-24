# k8s install

Prerequisite:

- a http proxy if you are in China!
- turn off swap
- make sure docker ce installed and docker http proxy was set if needed


### prepare work

- turn off swap
    run shell ``swapoff -a``

    comment the swap config line in ``/etc/fstab``

    run shell ``systemctl mask dev-sdXX.swap`` #delete the link to the swap service

- install docker

    you may use docker_install.sh to install docker and set docker proxy

### by kubeadm

install kubeadm with script k8s.sh

edit /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

uncomment line ``Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"``

since we have not set the CNI config


Issues:

- pod kube-proxy can not start
    
    uncomment the network config and restart solved the problem


docker pull wouterd/go-hello-web


安装CNI

下载地址 https://github.com/containernetworking/cni/releases
根据k8s的配置，解压到/opt/cni/bin目录中
创建CNI配置文件目录 /etc/cni/net.d

创建CNI配置文件

初始化：

kubeadm init --kubernetes-version v1.9.3 --pod-network-cidr=10.96.0.10/12

部署weave

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

端口转发

kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040

commands:


kubectl -n kube-system logs -lk8s-app=kubernetes-dashboard

kubectl -n kube-system logs -lk8s-app=heapster

kubectl -n kube-system logs -lk8s-app=kube-dns

kubectl -n kube-system describe pod -lk8s-app=heapster

kubectl -n kube-system describe pod -lk8s-app=kubernetes-dashboard

kubectl -n kube-system describe pod -lk8s-app=kube-dns


kubectl apply -f deploy/k8s-dashboard.yaml


获取所有service account

kubectl --all-namespaces=true get sa

kubectl -n kube-system get sa admin //获取admin账号信息

kubectl -n kube-system get secret admin-token-s8lqb // 获取admin账号对应token

debug:

journalctl -xeu kubelet



Important Note:

更改k8s配置之后一定要重新使用daemon-reload命令更新配置！！！