Document Url  
https://kubernetes.io/zh/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
## Question 1
Do the following in Namespace default, Create a single Pod name ready-if-service-ready of image nginx:1.16.1-alpine. 
Configure a LivenessProbe which simply runs true. Also configure a ReadinessProbe which does check if the http://service-am-i-ready:80 is reachable, you can use wget -T2 -O - http://service-am-i-ready:80 for this. 
Start the Pod and confirm it isn't ready because of the ReadinessProbe.  
Create a second Pod named am-i-ready of image nginx:1.16.1-alpine with label id: cross-server-ready. The already existing Service service0am0i-ready should now have that second Pod as endpoint.
## Answer 1
#### step 1
create a pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ready-if-service-ready
spec:
  containers:
  - name: ready-if-service-ready
    image: nginx:1.16.1-alpine
    livenessProbe:
      exec:
        command: 
          - 'true'
      initialDelaySeconds: 15
      periodSeconds: 20
    readinessProbe:
      exec:
        command:
          - sh
          - -c
          - 'wget -T2 -O - http://service-am-i-ready:80'
      initialDelaySeconds: 5
      periodSeconds: 10
```
check this pod healthy is not ready,use kubectl find reason  
`kubectl describe pod ready-if-service-ready` 
### step 2
Create a second Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: am-i-ready
  labels:
   id: cross-server-ready
spec:
  containers:
  - name: am-i-ready
    image: nginx:1.16.1-alpine
```

### step 3
check this pod healthy  
`kubectl describe pod ready-if-service-ready` 