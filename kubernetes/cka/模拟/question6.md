## Storage, PV, PVC, Pod volume
> Task weight: 8%

Use context: `kubectl config use-context k8s-c1-H`
## Question
Create a new PersistentVolume named `safari-pv`. It should have a capacity of `2Gi`, accessMode `ReadWriteOnce`, hostPath `/Volumes/Data` and no storageClassName defined.

Next create a new PersistentVolumeClaim in Namespace `project-tiger` named `safari-pvc` . It should request `2Gi` storage, accessMode `ReadWriteOnce` and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally, create a new Deployment `safari` in Namespace `project-tiger` which mounts that volume at `/tmp/safari-data`. The Pods of that Deployment should be of image `httpd:2.4.41-alpine`.

## Answer
### step 1
create pv named safari-pv
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: safari-pv
spec:
  capacity:
    storage: 2Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  local:
    path: /Volumes/Data
```
### step 2
create pvc named safari-pvc
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: safari-pvc
  namespace: project-tiger
spec:
  storageClassName: "" # 此处须显式设置空字符串，否则会被设置为默认的 StorageClass
  volumeName: safari-pv
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 2Gi
```

### step 3
`kubectl create deployment safari -n project-tiger --image httpd:2.4.41-alpine --dry-run -oyaml`  
Edit
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: safari
  name: safari
  namespace: project-tiger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: safari
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: safari
    spec:
      volumes:
        - name: safari-pvc
          persistentVolumeClaim:
            claimName: myclaim
      containers:
      - image: httpd:2.4.41-alpine
        name: httpd
`      volumeMounts:
        - mountPath: "/tmp/safari-data"
          name: safari-pvc`
        resources: {}
status: {}
```
### verify
`kubectl -n project-tiger describe pod safari-5cbf46d6d-mjhsb  | grep -A2 Mounts:`
```text
    Mounts:
      /tmp/safari-data from data (rw) # there it is
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-n2sjj (ro)
```