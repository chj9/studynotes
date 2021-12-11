Document Url  
https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#scale
##Question 1
Scale the deployment scale-deploy in namespace cka to three pod and record it.
##Answer 1
####step 1
`kubectl scale deployment scale-deploy  -n cka --replicas=3 --record` 
####step 2
`kubectl describe deployment scale-deploy -n cka`  
in annotations have value
```yaml
kubernetes.io/change-cause: kubectl scale deployment scale-deploy --replicas=3 --record=true
```
