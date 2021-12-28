## Question
Scale the deployment loadbalancer to 6 pods
## Answer
### step1
`kubectl scale --replicas=6 deployment/loadbalancer`  
Or  
`kubectl edit`