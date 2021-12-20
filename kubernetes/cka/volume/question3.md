Document Url  
https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/
## Question 1
Create a new PersistentVolume named safari-pv. it should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath /Volumes/Data and no storageClassName defined.  
Next create a new PersistentVolumeClaim in Namespace cka named safari-pvc. it should request 2Gi storage, accessMode RaedWriteOnce and should not define a storageClassName. The PVC should bound to the PV correctly.  
Finally, create a new Deployment safari in Namespace cka which mounts that volumes at /tmp/safari-data. The Pods of that Deployment should be of image httpd:2.4.41-alpine.
## Answer 1
### step 1
create persistent volume
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
    path: /data/test
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - k8s-111
```
### step 2
create persistent volume clain
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: safari-pvc
  namespace: cka
spec:
  volumeName: safari-pv
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  storageClassName: ""
  resources:
    requests:
      storage: 2Gi
```
### step 3
create a deployment name safari,use image nginx  
`kubectl create deployment safari --image=httpd:2.4.41-alpine  --dry-run=client -oyaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: safari
  name: safari
  namespace: cka
spec:
  replicas: 1
  selector:
    matchLabels:
      app: safari
  template:
    metadata:
      labels:
        app: safari
    spec:
      containers:
        - image: httpd:2.4.41-alpine
          name: httpd
          volumeMounts:
            - mountPath: "/tmp/safari-data"
              name: safari
      volumes:
        - name: safari
          persistentVolumeClaim:
            claimName: safari-pvc
```