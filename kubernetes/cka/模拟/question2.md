Task weight: 3%

Use context: kubectl config use-context k8s-c1-H

Create a single Pod of image httpd:2.4.41-alpine in Namespace default. The Pod should be named pod1 and the container should be named pod1-container. This Pod should only be scheduled on a master node, do not add new labels any nodes.

Shortly write the reason on why Pods are by default not scheduled on master nodes into /opt/course/2/master_schedule_reason .