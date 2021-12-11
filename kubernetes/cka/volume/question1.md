##Question 1
Create a pod name log, container name log-pro use image busybox, output the important information at /log/data/output.log,Then another container name log-cus use image busybox, load the output.log at /log/data/output.log and print it  
>Note,this log file only can be share within the pod.

##Answer 1
Document Url  
https://kubernetes.io/docs/concepts/storage/volumes/
###step 1
create a log_pod.yaml
run this command output config file
`kubectl run log --image=busybox --dry-run=client -oyaml > log-pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: log
  namespace: cka
spec:
  volumes:
    - name: log-volume
      emptyDir: {}
  containers:
  - image: busybox:latest
    name: log-pro
    command:
      - sh
      - -c
      - echo 'important information' >> /log/data/output.log;sleep 1d
    volumeMounts:
    - mountPath: /log/data/
      name: log-volume
  - image: busybox:latest
    name: log-cus
    command:
      - sh
      - -c
      - cat /log/data/output.log;sleep 1d
    volumeMounts:
      - mountPath: /log/data/
        name: log-volume
        readOnly: true
```
> busybox must execute the command sleep
###step 2
execute command  
`kubectl logs -f log -n cka -c log-cus`  
response **important information** successful