Document Url:  
https://kubernetes.io/zh/docs/tasks/configure-pod-container/assign-pods-nodes/
## Question
Schedule a pod as follows
- Name: `nginx-kusc00401`
- Image: `nginx`
- Node selector: `disk=spinning`
## Answer
### step 1
use kubectl dru-run generate  
`kubectl run nginx-kusc0040  --image nginx  --dry-run=client -oyaml`  
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx-kusc0040
  name: nginx-kusc0040
spec:
  containers:
  - image: nginx
    name: nginx-kusc0040
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  nodeSelector:
    disk: spinning
status: {}

```