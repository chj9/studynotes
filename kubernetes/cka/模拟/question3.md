## Scale down StatefulSet
> Task weight: 1%
## Question
Use context: `kubectl config use-context k8s-c1-H`

There are two Pods named o3db-* in Namespace project-c13. C13 management asked you to scale the Pods down to one replica to save resources. Record the action.

## Answer
### step 1
find pod resource
`kubectl get pods -n project-c13 | grep o3db-`
```shell
o3db-0                                  1/1     Running   0          52s
o3db-1                                  1/1     Running   0          42s
```

### step 2
`kubectl get deploy,ds,sts -n project-c13 | grep o3db`
```shell
statefulset.apps/o3db   2/2     2m56s
```

### step 2
`kubectl scale --replicas=1 sts o3db -n project-c13 --record`

### step 4
`kubectl describe sts o3db -n project-c13`
```shell
Name:               o3db
Namespace:          project-c13
CreationTimestamp:  Sun, 20 Sep 2021 14:47:57 +0000
Selector:           app=nginx
Labels:             <none>
Annotations:        kubernetes.io/change-cause: kubectl scale sts o3db --namespace=project-c13 --replicas=1 --record=true
Replicas:           1 desired | 1 total
```