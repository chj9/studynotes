## Question
From the pod label name=cpu-user, find pods running high CPU workloads and write the name of the pod consuming most CPU to the file /opt/KUTR00401/KUTR00401.txt (which already exists)  
CN  
找出具有name=cpu-user的Pod，并过滤出使用CPU最高的Pod，然后把它的名字写在已经存在的/opt/KUTR00401/KUTR00401.txt文件里（注意他没有说指定namespace。所以需要使用-A指定所以namespace）
## Answer
### step1
`kubectl top pod -A -l name=cpu-user  --sort-by='cpu' |  head -2`
response
```text
NAMESPACE                      NAME                                                CPU(cores)   MEMORY(bytes)   
rabbitmq-system                test-rabbitmq-server-2                              723m         824Mi    
```
write `test-rabbitmq-server-2` to /opt/KUTR00401/KUTR00401.txt   
`echo test-rabbitmq-server-2 >> /opt/KUTR00401/KUTR00401.txt`