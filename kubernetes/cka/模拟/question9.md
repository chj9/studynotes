Task weight: 5%

Use context: kubectl config use-context k8s-c2-AC

Ssh into the master node with ssh cluster2-master1. Temporarily stop the kube-scheduler, this means in a way that you can start it again afterwards.

Create a single Pod named manual-schedule of image httpd:2.4-alpine, confirm its started but not scheduled on any node.

Now you're the scheduler and have all its power, manually schedule that Pod on node cluster2-master1. Make sure it's running.

Start the kube-scheduler again and confirm its running correctly by creating a second Pod named manual-schedule2 of image httpd:2.4-alpine and check if it's running on cluster2-worker1.  
