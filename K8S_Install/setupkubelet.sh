#!/bin/bash
systemctl start kubelet && systemctl enable kubelet
systemctl start docker && systemctl enable docker

#no 10-kubeadm.conf till starting the kubelet service. Order matters

cg=`docker info 2>/dev/null | grep -i 'cgroup' | awk 'NR==1{print $3}'`
if [ "$cg" == "cgroupfs" ]
then
	sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/g' /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
fi

#probally got error saying kubelet/config.yaml not found. 
#Either run "kubeadm init..." on the master or "kubeadm join ..." on the worker can fix the error
systemctl daemon-reload
systemctl restart kubelet

#kubeadm init --apiserver-advertise-address=master_ip --pod-network-cidr=CIDR/offset
