## Question 1
Monitor the logs of pod foobar and:  
- Extract log lines corresponding to error `unable-to-access-website`
- Write them to /opt/KUTR00101/foobar  

CN
监控名为foobar的Pod的日志，并过滤出具有unable-access-website 信息的行，写入到指定文件夹
## Answer 1
#### step 1
`kubectl logs -f foobar | grep unable-to-access-website > /opt/KUTR00101/foobar`