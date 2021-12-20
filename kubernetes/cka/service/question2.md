Document Url  
https://kubernetes.io/zh/docs/tasks/configure-pod-container/static-pod/
https://kubernetes.io/zh/docs/tasks/configure-pod-container/assign-cpu-resource/
https://kubernetes.io/zh/docs/concepts/services-networking/connect-applications-service/
## Question 1
Create a Static Pod named my-static-pod in Namespace default on cluster3-master1. it should be of image nginx:1.16-alpine and have resource requests for 10m and 20Mi memory.  
Then create a NodePort Service named static-pod-service which exposes that static Pod on port 80 and check if it has Endpoints and if it's reachable through the cluster3-master1 internal IP address. You can connect to the internal node IPs from your main terminal.
## Answer 1
#### step 1
`ssh cluster3-master1`  
`cd /etc/kubernetes/manifests`
create pod  
```yaml
cat <<EOF >/etc/kubernetes/manifests/static-web.yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-static-pod
  labels:
    run: nginx
spec:
  containers:
  - name: container
    image: nginx:1.16-alpine
    ports:
        - containerPort: 80
    resources:
      requests:
        cpu: 10m
        memory: 20Mi
EOF
```
check pod running  
`kubectl get pod -A | grep my-static-pod-k8s`
### step 2
create service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: static-pod-service
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    run: nginx
```
### step 3
check it in terminal
`curl cluster1-master1:NodePort`