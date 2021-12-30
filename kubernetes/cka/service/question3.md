Document Url:  
https://kubernetes.io/zh/docs/concepts/services-networking/service/
## Question 1
Reconfigure the existing deployment front-end and add a port specification named http exposing port 80/tcp of the existing container nginx.  
Create a new service  named front-end-svc exposing the container port http.  
Configure the new service to also expose the individual Pods via a NodePort on the nodes on which they are scheduled.
## Answer 1
#### step 1
Get deployment label  
`kubectl get deployment front-end --show-labels`
#### step 2
```yaml
apiVersion: v1
kind: Service
metadata:
  name: front-end-svc
spec:
  type: NodePort
  selector:
    app: front-end
  ports:
      # 默认情况下，为了方便起见，`targetPort` 被设置为与 `port` 字段相同的值。
    - port: 80
      targetPort: 80
      # 可选字段
      # 默认情况下，为了方便起见，Kubernetes 控制平面会从某个范围内分配一个端口号（默认：30000-32767）
      nodePort: 30007
```
