## Question
Check to see how many nodes are ready (not including nodes tainted `NoSchedule`) and write the number to /opt/KUSC00402/kusc00402.txt  
CN  
检查集群中有多少节点为Ready状态，并且去除包含NoSchedule污点的节点。之后将数字写到/opt/KUSC00402/kusc00402.txt
## Answer
### step 1
Get ready node count  
`kubectl describe nodes | grep Ready`  
A
### step 2
Get including tainted   
`kubectl describe nodes | grep Tainted | grep NoSchedule`  
B
### step 2
A-B=C  
write C to /opt/KUSC00402/kusc00402.txt