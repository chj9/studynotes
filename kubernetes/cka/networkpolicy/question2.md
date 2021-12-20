Document Url  
https://kubernetes.io/docs/concepts/services-networking/network-policies/

## Question 1
There was security incident where an intruder was able to access the whole cluster from a single hacked backend Pod.  
To prevent this create a NetworkPolicy called np-backend in Namespace project-snake. It should allow the backend-* Pods only to:  
connect to db1-* Pods on port 1111  
connect to db2-* Pods on port 2222  
Use the app label of Pods in your policy  
After implementation, connections from backend-* Pods to vault-* Pods on pod 3333 should for example no longer work.
## Answer 1
> Understand the meaning of Ingress and egress
### step 1
get pod label
`kubectl get pods -n project-snake   --show-labels | grep backend-`
create network policy  

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-backend
  namespace: project-snake
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Egress
  egress:
    - to:
      - podSelector:
          matchLabels:
            role: db1
      ports:
        - protocol: TCP
          port: 1111
    - to:
        - podSelector:
            matchLabels:
              role: db2
      ports:
        - protocol: TCP
          port: 2222
```
`kubectl apply -f network.yaml`

### Step 2
test connect
```shell
kubectl -n project-snake exec backup-0 -- curl -s IP:PORT
```