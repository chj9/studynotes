Document Url  
https://kubernetes.io/zh/docs/tasks/debug-application-cluster/debug-cluster/
## Question 1
Now the node01 is not ready, please find out the root cause and make it to ready,then create a pod that make sure it is running on node01.
## Answer 1
### step1
get all nodes  
`kubectl get nodes`
### step2
```shell
kubectl describe node node01
systemctl status kubelet
```
### step3
Restart the kubelet
```shell
sudo systemctl restart kubelet
```
### step4
create a pod name nginx and node select node is node01
`kubectl run nginx --image=nginx`
