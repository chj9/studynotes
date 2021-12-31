## Pod Ready if Service is reachable
> Task weight: 4%

## Question
Use context: `kubectl config use-context k8s-c1-H`

Do the following in Namespace `default`. 
Create a single Pod named `ready-if-service-ready` of image `nginx:1.16.1-alpine`. 
Configure a LivenessProbe which simply runs `true`. 
Also configure a ReadinessProbe which does check if the url `http://service-am-i-ready:80` is reachable,
you can use `wget -T2 -O- http://service-am-i-ready:80` for this. 
Start the Pod and confirm it isn't ready because of the ReadinessProbe.

Create a second Pod named `am-i-ready` of image `nginx:1.16.1-alpine` with label `id: cross-server-ready`. 
The already existing Service `service-am-i-ready` should now have that second Pod as endpoint.

Now the first Pod should be in ready state, confirm that.

## Answer
### step 1
`kubectl run  ready-if-service-ready --image nginx:1.16.1-alpine --dry-run=client -oyaml> pod1.yaml`
Edit
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ready-if-service-ready
  name: ready-if-service-ready
spec:
  containers:
    - image: nginx:1.16.1-alpine
      name: ready-if-service-ready
      resources: {}
      livenessProbe:
        exec:
          command:
            - "true"
      readinessProbe:
        exec:
          command:
            - sh
            - -c
            - wget -T2 -O- http://service-am-i-ready:80
        initialDelaySeconds: 5
          port: 8080
        periodSeconds: 10
  dnsPolicy: ClusterFirst
  restartPolicy: Always
```

### step 2
`kubectl run am-i-ready --image nginx:1.16.1-alpine --dry-run=client -oyaml> pod2.yaml`
Edit
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    id: cross-server-ready
  name: am-i-ready
spec:
  containers:
  - image: nginx:1.16.1-alpine
    name: am-i-ready
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```