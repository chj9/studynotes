Document Url  
https://kubernetes.io/zh/docs/concepts/scheduling-eviction/assign-pod-node/
## Question 1
Create a Deployment named deploy-important with label id=very-important(the pods should also have this label) and 3 replicas in namespace dev. it should contain two containers, the first named container1 with image nginx and the second one named container2 with image kubernetes/pause.  
THere should be only ever one Pod of that Deployment running on one worker node, We have two worker nodes: cluster1-worker1 and cluster1-worker2. Because the Deployment has three replicas the result should be that on both nodes one Pod is running. The third Pod won't be scheduled, unless anew worker node will be added.
## Answer 1
#### step 1
create a deployment and add label id=very-important
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-important
  namespace: dev
  labels:
    id: very-important
spec:
  selector:
    matchLabels:
      id: very-important
  replicas: 3
  template:
    metadata:
      labels:
        id: very-important
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: id
                operator: In
                values:
                - very-important
            topologyKey: "kubernetes.io/hostname"
      containers:
      - name: container1
        image: nginx
      - name: container2
        image: kubernetes/pause
```
