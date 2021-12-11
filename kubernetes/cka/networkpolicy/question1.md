Document Url  
https://kubernetes.io/docs/concepts/services-networking/network-policies/

## Question 1
Only pods that in the internal namespace can access the pods in mysql namespace via port 8080/TCP

## Answer 1
> Understand the meaning of Ingress and egress
### step 1
create network policy  

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: mysql
spec:
  policyTypes:
  - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              ns: internal
      ports:
        - protocol: TCP
          port: 8080
```
`kubectl apply -f network.yaml`
### step 2
check if internal namespace has ns=internal label  
`kubectl get  ns internal --show-labels`  
If there is no label, add it  
`kubectl label namespace internal ns=internal`
