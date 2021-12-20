Document Url  
https://kubernetes.io/zh/docs/reference/kubectl/kubectl-cmds/
## Question 1
You have access to multiple cluster from your main terminal through kubectl contexts. Write all those context names into /opt/course/1/contexts.  
Next write a command to display the current context into /opt/course/1/context_default_kubectl.sh,the command should use kubectl.  
Finally, write a second command doing the same thing into /opt/course/1/context_default_no_kubectl.sh, but without the use of kubectl.
## Answer 1
#### step 1

`echo "kubectl config  get-contexts -o name" >  /opt/course/1/contexts`

#### step 2
`echo "kubectl config current-context" > /opt/course/1/context_default_kubectl.sh`

### step 3
`echo "cat ~/.kube/config | grep current" > /opt/course/1/context_default_no_kubectl.sh`