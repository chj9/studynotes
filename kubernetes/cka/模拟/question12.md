Task weight: 6%

Use context: kubectl config use-context k8s-c1-H

Use Namespace project-tiger for the following. Create a Deployment named deploy-important with label id=very-important (the Pods should also have this label) and 3 replicas. It should contain two containers, the first named container1 with image nginx:1.17.6-alpine and the second one named container2 with image kubernetes/pause.

There should be only ever one Pod of that Deployment running on one worker node. We have two worker nodes: cluster1-worker1 and cluster1-worker2. Because the Deployment has three replicas the result should be that on both nodes one Pod is running. The third Pod won't be scheduled, unless a new worker node will be added.

In a way we kind of simulate the behaviour of a DaemonSet here, but using a Deployment and a fixed number of replicas.

