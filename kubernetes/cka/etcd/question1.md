Document Url  
https://kubernetes.io/zh/docs/tasks/administer-cluster/configure-upgrade-etcd/

## Question 1
Make a backup of etcd and save it on the master node at /root/cka/etcd-backup.db.
## Answer 1
#### seep 1
Get Etcd pod name  
`kubectl get pods -n kube-system  | grep etcd`
```yaml
kube-system                    etcd-k8s-111                                                      1/1     Running     5          80d
kube-system                    etcd-k8s-112                                                      1/1     Running     5          35d
kube-system                    etcd-k8s-113                                                      1/1     Running     5          35d
```
Get any one pod describe info  
`kubectl describe pod  etcd-k8s-111 -n kube-system`  
![img.png](../../image/8.png)  
remember these three configurations
```
--cert-file=/etc/kubernetes/pki/etcd/server.crt
--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
--key-file=/etc/kubernetes/pki/etcd/server.key
```
#### step 1
Document demo
```shell
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
--cacert=<trusted-ca-file> --cert=<cert-file> --key=<key-file> \
snapshot save <backup-file-location>
```
Answer
```shell
ETCDCTL_API=3 etcdctl --endpoints https://k8s-01:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /root/cka/etcd-backup.db.
```
If there is a requirement for backup and recovery
```shell
ETCDCTL_API=3 etcdctl --data-dir /root/cka/etcd-backup snapshot restore /root/cka/etcd-backup.db
```