Document Url  
https://kubernetes.io/zh/docs/reference/access-authn-authz/rbac/
## Question 1
Create a service account name dev-sa in default namespace,dev-sa can blow components in dev namespace:
- Deployment
- StatefulSet
- DaemonSet
## Answer 1
#### step 1
document url  
https://kubernetes.io/zh/docs/tasks/configure-pod-container/configure-service-account/  
create service account  
`kubectl create sa dev-sa`
#### step 2
create role.yaml
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: cka
  name: dev-role
rules:
- apiGroups: ["*"]
  resources: ["deployments","statefulsets","daemonsets"]
  verbs: ["create"]
```
`kubectl apply -f role.yaml`

> Note that the resource object suffix has an extra s, the old version may not
#### step 3
create rolebinding.yaml
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev
  namespace: cka 
subjects:
- kind: ServiceAccount
  name: dev-sa # "name" is case sensitive
  namespace: default
roleRef:
  # "roleRef" specifies the binding to a Role / ClusterRole
  kind: Role #this must be Role or ClusterRole
  name: dev-role # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: "rbac.authorization.k8s.io"
```
`kubectl apply -f rolebinding.yaml`
### step 4
verify  

`kubectl auth can-i  create daemonset  -n cka --as system:serviceaccount:default:dev-sa`  
yes  
`kubectl auth can-i  create statefulset  -n cka --as system:serviceaccount:default:dev-sa`  
yes  
`kubectl auth can-i  create deployment  -n cka --as system:serviceaccount:default:dev-sa`  
yes  
all response `yes` are successful