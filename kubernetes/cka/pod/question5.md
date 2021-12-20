Document Url  

## Question 1
There are various Pods in all namespaces, Write a command into /opt/find_pod_1.sh which lists all Pods sorted by their AGE(metadata.creationTimestamp)  
Write second command into /opt/find_pod_2.sh which lists all Pods sorted by field metadata.uid,Use kubectl sorting fot both commands. 
## Answer 1
#### step 1

`echo "kubectl get pods  -A  --sort-by='.metadata.creationTimestamp'" > /opt/find_pod_1.sh`
 
`echo "kubectl get pods  -A  --sort-by='.metadata.uid'" > /opt/find_pod_2.sh`

