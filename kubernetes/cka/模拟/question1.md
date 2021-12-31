## Contexts

> Task weight: 1%

## Question
You have access to multiple clusters from your main terminal through `kubectl` contexts. Write all those context names into `/opt/course/1/contexts`.

Next write a command to display the current context into `/opt/course/1/context_default_kubectl.sh`, the command should use kubectl.

Finally, write a second command doing the same thing into `/opt/course/1/context_default_no_kubectl.sh`, but without the use of kubectl.

## Answer
### step 1
`kubectl config get-contexts -o name > /opt/course/1/contexts`  

Or using jsonpath:
```shell
kubectl config view -o yaml # overview
kubectl config view -o jsonpath="{.contexts[*].name}"
kubectl config view -o jsonpath="{.contexts[*].name}" | tr " " "\n" # new lines
kubectl config view -o jsonpath="{.contexts[*].name}" | tr " " "\n" > /opt/course/1/contexts 
```


### step 2
`echo "kubectl config current-context" > /opt/course/1/context_default_kubectl.sh`

### step 3
`echo "cat ~/.kube/config | grep current-context | sed -e "s/current-context: //"" > /opt/course/1/context_default_no_kubectl.sh`
