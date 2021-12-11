##Question 1
Count the ready node in this cluster that without have a taint, and output the number ti file /root/cka/read/readyNode.txt

##Answer 1
###step 1
Get ready node count  
`kubectl get nodes | grep -w  Ready | wc -l`  
5
###step 2
Get have taint node count
`kubectl describe node | grep Taints | grep -I NoSchedule | wc -l`
1
###step3
5-1=4  
`echo 4 > /root/cka/read/readyNode.txt`