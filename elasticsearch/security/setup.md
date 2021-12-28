### 一. 版本
测试版本: `7.16.2`  
其他版本也可以按这个来
### 二. 升级与开启安全步骤官方文档
https://www.elastic.co/guide/en/elasticsearch/reference/7.16/security-basic-setup.html
### 三. 生成 ssl 证书
可以先下载一个离线包生成公钥秘钥  
1.生成公钥  
`ES_JAVA_HOME=${PWD}/jdk ./bin/elasticsearch-certutil ca`

2.生成私钥  
`ES_JAVA_HOME=${PWD}/jdk  ./bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12 --days 9999`
>用 ES certutil 工具生成的证书，默认有效期是 3 年(1095天)，`有效期一到节点之间就连不上`,所以需要注意做证书的管理
>

验证证书有效期  
`openssl pkcs12 -in elastic-certificates.p12 -nodes | openssl x509 -noout -dates`
```text
Enter Import Password:
MAC verified OK
开始时间
notBefore=Dec 27 03:31:29 2021 GMT
结束时间
notAfter=May 13 03:31:29 2049 GMT
```
生成elastic-certificates.p12私钥文件，保存好  

3.在每个节点配置文件下面下面创建certs文件夹，配置文件在/etc/elasticsearch,然后把以上生成的私钥copy到每个节点的节点下面，生成的私钥名称为`elastic-certificates.p12`  
### 四. 容器安全配置方式
可以参考官方这步  
https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls-docker.html  
但是我是需要装一些插件的，就直接重新build一个镜像了  
这步重新build镜像即可，参考Dockerfile
```docker
FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.2
COPY --chown=1000:1000 ./repository-s3 /usr/share/elasticsearch/plugins/repository-s3
RUN mkdir -p /usr/share/elasticsearch/config/certs/
COPY --chown=1000:1000 ./certs/elastic-certificates.p12 /usr/share/elasticsearch/config/certs/
RUN chmod 600 /usr/share/elasticsearch/config/certs/elastic-certificates.p12
RUN echo atai | /usr/share/elasticsearch/bin/elasticsearch-keystore add s3.client.minio.access_key -xf
RUN echo wJalrXUtnFK7MDP | /usr/share/elasticsearch/bin/elasticsearch-keystore add s3.client.minio.secret_key -xf
RUN echo HYz4jfB7wuZpPeK | /usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password -xf
RUN echo HYz4jfB7wuZpPeK | /usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password -xf
```
`HYz4jfB7wuZpPeK`为加密通信的证书密码，就是生成证书的时候需要输入的密码，也可以直接为空

### 五.配置ssl集群通信

修改每个节点的elasticsearch.yml,加入如下的内容
```yaml
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.client_authentication: required
xpack.security.transport.ssl.keystore.path: certs/elastic-certificates.p12 
xpack.security.transport.ssl.truststore.path: certs/elastic-certificates.p12 
```
### 六. 生成账户密码
重启集群
#### 方式一:
随机产生elasticsearch、kibana和logstash_system用户的新密码  
`./bin/elasticsearch-setup-passwords atuo`  
得到执行结果保存
```text
Initiating the setup of passwords for reserved users elastic,apm_system,kibana,logstash_system,beats_system,remote_monitoring_user.
The passwords will be randomly generated and printed to the console.
Please confirm that you would like to continue [y/N]y
Changed password for user apm_system
PASSWORD apm_system = ****************
Changed password for user kibana
PASSWORD kibana = ****************
Changed password for user logstash_system
PASSWORD logstash_system = ****************
Changed password for user beats_system
PASSWORD beats_system = ****************
Changed password for user remote_monitoring_user
PASSWORD remote_monitoring_user = ****************
Changed password for user elastic
PASSWORD elastic = ****************
```
#### 方式二:
自定义设置elasticsearch、kibana和logstash_system用户的新密码  
`./bin/elasticsearch-setup-passwords interactive`  
### 七. ES 配置参考
testing-0 节点的 elasticsearch.yaml 配置如下
```yaml
cluster:
  name: test
  initial_master_nodes:
    - testing-0
    - testing-1
    - testing-2
discovery:
  seed_hosts:
    - testing-0
    - testing-1
    - testing-2
network:
  publish_host: 172.17.20.47
node:
  name: testing-0
path:
  data: /usr/share/elasticsearch/data
  logs: /usr/share/elasticsearch/logs
s3:
  client:
    minio:
      endpoint: http://172.17.20.120:9000
xpack:
  security:
    authc:
      api_key:
        enabled: true
    enabled: "true"
    http:
      ssl:
        enabled: false
    transport:
      ssl:
        keystore:
          path: certs/elastic-certificates.p12
        truststore:
          path: certs/elastic-certificates.p12 
        enabled: "true"
        client_authentication: required
        verification_mode: certificate
```

### 八. kibana配置修改
```yaml
elasticsearch.username: "kibana"
elasticsearch.password: 密码为在elasticsearch 第六步骤中生成的密码
#如果需要认证访问则需要开启此项
xpack.security.enabled: true
server.publicBaseUrl: http://testing-0:5601
```
### 九. 创建应用读写账号

创建角色`index_operate`
```shell
curl -XPOST   -H 'Content-Type: application/json'  -u elastic:password  testing-0:9200/_security/role/index_operate  -d  '{"indices":[{"names":["*"],"privileges":["create","delete","index","manage","read"]}]}'
```
创建用户`operater`,密码为`l0ngr4nd0mpw0rd` ,程序里的账号密码则是填写这个
```shell
curl -XPOST   -H 'Content-Type: application/json'  -u elastic:password  testing-0:9200/_security/user/operater  -d  '{"password":"l0ngr4nd0mpw0rd","roles":["index_operate"],"full_name":"Test"}'
```
验证用户是否有权限
```shell
curl -H "es-security-runas-user: operater"  -u elastic:password -XGET 'http://localhost:9200/'
```

### 十. Java兼容安全模式连接池代码写法
该方式可以先以非账号密码访问如果返回403则再以账号密码访问
```java
    final CredentialsProvider credentialsProvider =
            new BasicCredentialsProvider();
    credentialsProvider.setCredentials(AuthScope.ANY,
            new UsernamePasswordCredentials("elastic", "password"));
    RestClientBuilder builder = RestClient.builder(
                    new HttpHost("testing-0", 9200, "http"),
                    new HttpHost("testing-1", 9201, "http"))
            .setHttpClientConfigCallback(httpClientBuilder -> {
                httpClientBuilder.disableAuthCaching();
                return httpClientBuilder
                        .setDefaultCredentialsProvider(credentialsProvider);
            });
    RestHighLevelClient client = new RestHighLevelClient(builder);
    GetIndexRequest request = new GetIndexRequest("test");


    boolean exists = client.indices().exists(request, RequestOptions.DEFAULT);
    System.out.println(exists);
    client.close();
```
### 十一. 影响
所有涉及需要连ES的都需要加上账号密码配置  
升级期间无法访问。无法回滚。除非对数据做了备份才能做回滚操作。
