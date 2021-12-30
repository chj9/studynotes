## Question
Set the node named ek8s-node-1 as unavailable and reschedule all the pods running on it.
## Answer
### step 1
`kubectl uncordon  ek8s-node-1`  
`kubectl drain ek8s-node-1 --delete-emptydir-data --ignore-daemonsets --force`  

