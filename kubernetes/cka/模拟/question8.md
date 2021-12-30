Task weight: 2%

Use context: kubectl config use-context k8s-c1-H

Ssh into the master node with ssh cluster1-master1. Check how the master components kubelet, kube-apiserver, kube-scheduler, kube-controller-manager and etcd are started/installed on the master node. Also find out the name of the DNS application and how it's started/installed on the master node.

Write your findings into file /opt/course/8/master-components.txt. The file should be structured like:


```text
# /opt/course/8/master-components.txt
kubelet: [TYPE]
kube-apiserver: [TYPE]
kube-scheduler: [TYPE]
kube-controller-manager: [TYPE]
etcd: [TYPE]
dns: [TYPE] [NAME]
```
Choices of [TYPE] are: not-installed, process, static-pod, pod