Document Url  
https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster

## Question 1
Make a backup of etcd and save it on the master node at /root/cka/etcd-backup.db.
## Answer 1
#### step 1
`kubectl cluster-info`
`ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save /root/cka/etcd-backup.db`