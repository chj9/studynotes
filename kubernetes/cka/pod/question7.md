Document Url  
https://kubernetes.io/zh/docs/reference/kubectl/kubectl-cmds/
## Question 1
There are two Pods named o3db-* in Namespace cka. C13 management asked you to scale the Pods down to one replica to save resources. Record the action
## Answer 1
#### step 1
`kubectl get pod -n cka | grep o3db`

### step 2
if response result the pod name is o3db-1,then get manage pod resource type  
`kubectl get deploy,sts,ds -n cka | grep o3db-1`

### step 3
scale replica to 1 and record  
`kubectl scale --replicas=1 -n cka sts/o3db  --record`