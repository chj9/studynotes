## Question
Create a pod named kucc1 with a single app container for each of the following images running inside (there may be between 1 and 4 images specified): nginx+redis+memcached+consul
## Answer
### step1
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: kucc1
  name: kucc1
spec:
  containers:
  - image: nginx
    name: nginx
    
  - image: redis
    name: redis
    
  - image: memcached
    name: memcached
    
  - image: consul
    name: consul
    
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```