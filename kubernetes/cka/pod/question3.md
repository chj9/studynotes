Document Url  
https://kubernetes.io/zh/docs/concepts/configuration/secret/
https://kubernetes.io/zh/docs/concepts/scheduling-eviction/taint-and-toleration/
## Question 1
Create a pod named secret-pod of image busybox:1.31.1 in namespace secret which should keep running for some time,it should be able to run on master nodes as well,create the proper toleration.  
There is existing Secret file name secret1.yaml,create it in the secret Namespace and mount it readonly into the Pod at /tmp/secret1.  
Create a new Secret in Namespace secret called secret2 which should contain user=user1 and pass=1234. These entries should be available inside the Pod's container as environment variables APP_USER and APP_PASS.
## Answer 1
#### step 1
get master node taint  
`kubectl describe node master | grep Taints`

#### step 2
create secret  
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret2
  namespace: secret
type: kubernetes.io/basic-auth
stringData:
  user: user1
  pass: 1234
```
### step 3
`vim secret1.yaml` and create it in Namespace secret

#### step 4
create a pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
  namespace: secret
spec:
  containers:
    - name: busybox
      image: busybox:1.31.1
      command: ["sh","-c","sleep 1d"]
      imagePullPolicy: IfNotPresent
    volumeMounts:
      - name: secret1
        mountPath: "/tmp/secret1"
        readOnly: true
    env:
      - name: APP_USER
        valueFrom:
          secretKeyRef:
            name: secret2
            key: user
      - name: APP_PASS
        valueFrom:
          secretKeyRef:
            name: secret2
            key: pass
  tolerations:
    - key: "example-key"
      operator: "Equal"
      value: "rexx"
      effect: "NoSchedule"
  volumes:
    - name: secret1
      secret:
        secretName: secret1
```