## Kill Scheduler, Manual Scheduling
> Task weight: 5%

## Question
Use context: `kubectl config use-context k8s-c2-AC`

Ssh into the master node with `ssh cluster2-master1`. Temporarily stop the `kube-scheduler`, this means in a way that you can start it again afterwards.

Create a single Pod named `manual-schedule` of image `httpd:2.4-alpine`, confirm its started but not scheduled on any node.

Now you're the scheduler and have all its power, manually schedule that Pod on node `cluster2-master1`. Make sure it's running.

Start the `kube-scheduler` again and confirm its running correctly by creating a second Pod named `manual-schedule2` of image `httpd:2.4-alpine` and check if it's running on `cluster2-worker1`. 

## Answer
### step 1
`cd /etc/kubernetes/manifests/ && mv kube-scheduler.yaml ../`  
now scheduler pod is stopped
### step 2
create pod  
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
  nodeName: cluster2-master1 # add the master node name
  containers:
  - image: httpd:2.4-alpine
    name: manual-schedule
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
Document url https://kubernetes.io/zh/docs/concepts/scheduling-eviction/assign-pod-node/#nodename

### step 3
start kube-scheduler  
`mv /etc/kubernetes/kube-scheduler.yaml /etc/kubernetes/manifests/kube-scheduler.yaml`  
create pod named manual-schedule2  
`kubectl run manual-schedule2 --image httpd:2.4-alpine`  

`kubectlget pod -o wide | grep schedule`
```shell
manual-schedule    1/1     Running   ...   cluster2-master1
manual-schedule2   1/1     Running   ...   cluster2-worker1
```