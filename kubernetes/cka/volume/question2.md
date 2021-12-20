Document Url  
https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/
## Question 1
There is a persistent volume name dev-pv in the cluster,create a persistent volume clain name dev-pvc,make sure this persistent volume clain will bound the persistent volume, and then create a pod name test-pvc that mount this pvc at path /tmp/data, use nginx image.

## Answer 1
### step 1
get persistent volume name dev-pv then get storage class and `accessModes` and `resources request storage`
`kubectl get pv dev-pv`  
`kubectl describe pv dev-pv`

### step 2
create persistent volume clain
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dev-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
### step 3
create a pod name test-dev,use image nginx  
`kubectl run test-dev --image nginx --dry-run=client -oyaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: test-dev
  name: test-dev
spec:
  containers:
  - image: nginx
    name: test-dev
    volumeMounts:
      - mountPath: "/tmp/data"
        name: mypd
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: dev-pvc
```