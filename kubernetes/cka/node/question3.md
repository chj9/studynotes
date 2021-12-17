Document Url  
https://kubernetes.io/zh/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
## Question 1
Upgrade the master node version from 1.19.0 to 1.20.0, make sure that the pod on master node should reschedule to other node, after upgrade, then make the master node available. 
## Answer 1
### step1
Drain the node  
`kubectl drain master --ignore-daemonsets`
### step2
Upgrade kubelet
```shell
apt-mark unhold kubelet && \
apt-get update && apt-get install -y kubelet=1.20.0-00 kubectl=1.20.0-00 && \
apt-mark hold kubelet
```
Restart the kubelet  
```shell
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```
### step3
Uncordon the node  
`kubectl uncordon master`
