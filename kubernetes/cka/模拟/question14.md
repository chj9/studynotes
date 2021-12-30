Task weight: 2%

Use context: kubectl config use-context k8s-c1-H

You're ask to find out following information about the cluster k8s-c1-H:

1. How many master nodes are available?
2. How many worker nodes are available?
3. What is the Service CIDR?
4. Which Networking (or CNI Plugin) is configured and where is its config file?
5. Which suffix will static pods have that run on cluster1-worker1?


Write your answers into file /opt/course/14/cluster-info, structured like this:
```text
# /opt/course/14/cluster-info
1: [ANSWER]
2: [ANSWER]
3: [ANSWER]
4: [ANSWER]
5: [ANSWER]
```

1 2 10.244.0.0/24  weave-net cluster1-master1


重点题