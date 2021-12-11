Document Url  
https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/
##Question 1
There is pod name pod-nginx, create a service name service-nginx, use nodePort to expose the pod,That create a pod use image busybox to nslookup the pod pod-nginx and service service-nginx

##Answer 1
### step 1
execute command output config to a file  
`kubectl run pod-nginx --image=nginx --dry-run=client -oyaml > pod-nginx.yaml`  
supplement the configuration
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod-nginx
  name: pod-nginx
spec:
  containers:
  - image: nginx
    name: pod-nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

---
apiVersion: v1                            
kind: Service
metadata:
  name: service-nginx
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    run: pod-nginx
```
`kubectl apply -f pod-nginx.yaml -n cka`  
pod/pod-nginx created  
service/pod-nginx created  
###step 2
execute command output config to a file  
`kubectl run pod-1 --image=nginx --dry-run=client -oyaml > pod-nginx.yaml`  
supplement the configuration
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod-1
  name: pod-1
spec:
  containers:
  - image: busybox
    name: pod-1
    command: 
      - sh
      - -c
      - sleep 1d
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
`kubectl apply -f pod-1.yaml -n cka`
###step3
Pod  
`kubectl get pod -owide`  
`kubectl exec -it busybox -- nslookup <pod-ip>`  
Service  
`kubectl exec -it busybox -- nslookup service-nginx.cka`
