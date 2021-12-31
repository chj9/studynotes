## Kubectl sorting
> Task weight: 1%

## Question
Use context: `kubectl config use-context k8s-c1-H`

There are various Pods in all namespaces. 
Write a command into `/opt/course/5/find_pods.sh` 
which lists all Pods sorted by their AGE (`metadata.creationTimestamp`).

Write a second command into `/opt/course/5/find_pods_uid.sh`
which lists all Pods sorted by field `metadata.uid`. Use kubectl sorting for both commands.


## Answer
### step 1
`kubectl get pods -A --sort-by='.metadata.creationTimestamp'`  
write to /opt/course/5/find_pods.sh

### step 2
`kubectl get pods -A --sort-by='.metadata.uid'`  
write to /opt/course/5/find_pods_uid.sh