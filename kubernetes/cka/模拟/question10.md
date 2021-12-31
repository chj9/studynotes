## RBAC ServiceAccount Role RoleBinding
> Task weight: 6%

## Question
Use context: `kubectl config use-context k8s-c1-H`

Create a new ServiceAccount `processor` in Namespace `project-hamster`. Create a Role and RoleBinding, both named `processor` as well. These should allow the new SA to only create Secrets and ConfigMaps in that Namespace.

## Answer
### step 1
`kubectl create sa processor -n project-hamster`

### step 2
``