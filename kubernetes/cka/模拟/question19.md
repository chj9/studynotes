Task weight: 3%

this task can only be solved if questions 18 or 20 have been successfully implemented and the k8s-c3-CCC cluster has a functioning worker node

Use context: kubectl config use-context k8s-c3-CCC

Do the following in a new Namespace secret. Create a Pod named secret-pod of image busybox:1.31.1 which should keep running for some time, it should be able to run on master nodes as well.

There is an existing Secret located at /opt/course/19/secret1.yaml, create it in the secret Namespace and mount it readonly into the Pod at /tmp/secret1.

Create a new Secret in Namespace secret called secret2 which should contain user=user1 and pass=1234. These entries should be available inside the Pod's container as environment variables APP_USER and APP_PASS.

Confirm everything is working.