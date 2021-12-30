Task weight: 3%

Use context: kubectl config use-context k8s-c1-H

In Namespace project-tiger create a Pod named tigers-reunite of image httpd:2.4.41-alpine with labels pod=container and container=pod. Find out on which node the Pod is scheduled. Ssh into that node and find the containerd container belonging to that Pod.

Using command crictl:

Write the ID of the container and the info.runtimeType into /opt/course/17/pod-container.txt

Write the logs of the container into /opt/course/17/pod-container.log

重点提