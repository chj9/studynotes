## Node and Pod Resource Usage
> Task weight: 1%

## Question
Use context: `kubectl config use-context k8s-c1-H`

The metrics-server hasn't been installed yet in the cluster, but it's something that should be done soon. Your college would already like to know the kubectl commands to:

1. show node resource usage
2. show Pod and their containers resource usage  

Please write the commands into /opt/course/7/node.sh and /opt/course/7/pod.sh.

## Answer
### step 1
`kubectl top node`
### step 2
`kubectl top pods  -A  --containers`