## Schedule Pod on Master Node
> Task weight: 3%
## Question
Use context: `kubectl config use-context k8s-c1-H`

Create a single Pod of image `httpd:2.4.41-alpine` in Namespace `default`. The Pod should be named `pod1` and the container should be named `pod1-container`. This Pod should only be scheduled on a master node, do not add new labels any nodes.

Shortly write the reason on why Pods are by default not scheduled on master nodes into `/opt/course/2/master_schedule_reason`.

## Answer
### step 1
```shell
kubectl get node # find master node

kubectl describe node cluster1-master1 | grep Taint # get master node taints

kubectl describe node cluster1-master1 | grep Labels -A 10 # get master node labels

kubectl get node cluster1-master1 --show-labels # OR: get master node labels
```
### step 2
`kubectl run pod1 --image httpd:2.4.41-alpine --dry-run=client -oyaml`  

Edit yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod1
  name: pod1
spec:
  containers:
    - image: httpd:2.4.41-alpine
      name: pod1-container                  # change
      resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  tolerations:                            # add
    - effect: NoSchedule                    # add
      key: node-role.kubernetes.io/master   # add
  nodeSelector:                           # add
    node-role.kubernetes.io/master: ""    # add
status: {}
```
apply this pod yaml
`kubectl apply -f pod.yaml`

### step 3
`echo "master nodes usually have a taint defined" > /opt/course/2/master_schedule_reason`