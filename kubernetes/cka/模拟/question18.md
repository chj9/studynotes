Task weight: 8%

Use context: kubectl config use-context k8s-c3-CCC

There seems to be an issue with the kubelet not running on cluster3-worker1. Fix it and confirm that cluster3 has node cluster3-worker1 available in Ready state afterwards. You should be able to schedule a Pod on cluster3-worker1 afterwards.

Write the reason of the issue into /opt/course/18/reason.txt.

```shell
➜ k get node
NAME               STATUS     ROLES    AGE   VERSION
cluster3-master1   Ready      master   27h   v1.22.1
cluster3-worker1   NotReady   <none>   26h   v1.22.1
```