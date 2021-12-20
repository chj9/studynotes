Document url  
https://kubernetes.io/zh/docs/concepts/scheduling-eviction/assign-pod-node/#nodename
## Question
Ssh into the master node with ssh cluster2-master1. Temporarily stop the kube-scheduler, this means in a way that you can start it again afterwards.  
Create a single Pod named manual-schedule of image httpd:2.4-alpine, confirm it's started but not scheduled on any node.  
Now you're the scheduler and have all it's power, manually schedule that Pod on node cluster2-master1. Make sure it's running.  
Start the kube-scheduler again and confirm it's running correctly by creating a second Pod named manual-schedule2 of image httpd:2.4-alpine and check if it's running on cluster2-worker1.
## Answer
### step1
Because kube-scheduler is a static pod, stop kube-scheduler in cluster2-master1, you can move `kube-scheduler.yaml` to another folder, k8s will automatically delete kube-scheduler.  
`mv /etc/kubernetes/manifests/kube-scheduler.yaml /home/cka/`
now kube-scheduler status is stopped

### step2
Create a pod named manual-schedule  
`kubectl run manual-schedule --image httpd:2.4-alpine --dry-run=client -oyaml`  
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: manual-schedule
  name: manual-schedule
spec:
  nodeName: cluster2-master1
  containers:
  - image: httpd:2.4-alpine
    name: manual-schedule
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
```
add `nodeName: cluster2-master1` will not use kube-scheduler to schedule the pod,then pod will run.
>Using this method will no longer be restricted by taint and affinity, and will be ignored directly


### Step3
Create a pod named manual-schedule2 
`kubectl run manual-schedule2 --image httpd:2.4-alpine --dry-run=client -oyaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: manual-schedule2
  name: manual-schedule2
spec:
  containers:
  - image: httpd:2.4-alpine
    name: manual-schedule2
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  nodeSelector:
    kubernetes.io/hostname: "cluster2-worker1"
```