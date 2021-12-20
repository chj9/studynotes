Document Url  
https://kubernetes.io/zh/docs/concepts/scheduling-eviction/assign-pod-node/
https://kubernetes.io/zh/docs/concepts/scheduling-eviction/taint-and-toleration/
## Question 1
Create a single Pod of image httpd:2.4.41-alpine in Namespace default. The Pod should be named pod1 and the container should be named pod1-container. This Pod should only be scheduled on a master node,do not add new labels any nodes.
## Answer 1
#### step 1
get master node label  
`kubectl get node master --show-labels`  
get master node taint  
`kubectl describe node master | grep Taints`
#### step 2
create pod  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod1
spec:
  containers:
    - name: pod1-container
      image: httpd:2.4.41-alpine
      imagePullPolicy: IfNotPresent
  nodeSelector:
    kubernetes.io/master: ""
  tolerations:
    - key: "kubernetes.io/master"
      operator: "Exists"
      effect: "NoSchedule"
```
