# 目录
```
├── inventories                                 ansible inventory
│   ├── beats                                   beats 部署目录
│   └── elk                                     elk 组件目录
└── playbooks
    ├── beats-full-reconfigure.yml
    ├── beats-rolling-reconfigure.yml
    ├── beats-setup-enroll.yml
    ├── beats-setup.yml
    ├── elasticsearch-full-reconfigure.yml
    ├── elasticsearch-rolling-reconfigure.yml
    ├── elasticsearch-setup.yml
    ├── files
    ├── kafka-zookeeper-setup.yml
    ├── kibana-setup.yml
    ├── logstash-full-reconfigure.yml
    ├── logstash-rolling-reconfigure.yml
    ├── logstash-setup.yml
    └── roles
```

# 命令行工具
```
wget https://s3.cn-north-1.amazonaws.com.cn/puxiang-public-packages/tools/px-deploy/console && chmod +x console
```

# ELK

## 配置
1.在 inventories/elk/hosts 中添加主机地址 (不能使用 /etc/hosts 中配置的别名)
2.在 inventories/elk/group_vars 中配置相关参数

## 部署 ES
```
ansible-playbook -i inventories/elk/hosts playbooks/elasticsearch-setup.yml
```
## 部署 Kibana
```
ansible-playbook -i inventories/elk/hosts playbooks/kibana-setup.yml
```
## 部署 Logstash
```
ansible-playbook -i inventories/elk/hosts playbooks/logstash-setup.yml
```
## 部署 Kafka-Zookeeper
```
ansible-playbook -i inventories/elk/hosts playbooks/kafka-zookeeper-setup.yml
```

## 其他
1. 登录一台 es 服务器，生成密码：/usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto

2. 修改 kibana 密码和 kibana_password 变量一致
```
curl -u elastic:****** -XPOST "http://127.0.0.1:9200/_security/user/kibana/_password" -H 'Content-Type: application/json' -d'
{
  "password" : "px_kibana_passwd"
}'
```

3. 修改 logstash_system 密码和 logstash_system_password 变量一致

```
curl -u elastic:****** -XPOST "http://127.0.0.1:9200/_security/user/logstash_system/_password" -H 'Content-Type: application/json' -d'
{
  "password" : "px_logstash_system_passwd"
}'
```

4. 修改 beats_system 密码和 beats_system_password 变量一致

```
curl -u elastic:****** -XPOST "http://127.0.0.1:9200/_security/user/beats_system/_password" -H 'Content-Type: application/json' -d'
{
  "password" : "px_beats_system_passwd"
}'
```

5. （如果开启 xpack 选项）创建 logstash_admin 用户，赋予 logstash_admin, logstash_system 角色，密码和 logstash_admin_password 变量一致

```
curl -u elastic:****** -XPOST "http://127.0.0.1:9200/_security/user/logstash_admin"  -H 'Content-Type: application/json' -d'
{
  "password" : "px_logstash_admin_passwd",
  "roles" : [ "logstash_admin", "logstash_system" ],
  "full_name" : "logstash_admin",
  "email" : "logstash_admin@example.com"
}'
```

6. 创建 writer 角色 和 writer 用户：

```
curl -u elastic:****** -XPOST "http://127.0.0.1:9200/_security/role/writer"  -H 'Content-Type: application/json' -d'
{
  "cluster": ["monitor","read_ilm","manage_ingest_pipelines","manage_ilm","manage_index_templates"],
  "indices": [
    {
      "names": [ "*" ],
      "privileges": ["create","create_index","index","write","manage_ilm","view_index_metadata","manage"],
    }
  ]
}'

curl -u elastic:****** -XPOST "http://127.0.0.1:9200/_security/user/writer"  -H 'Content-Type: application/json' -d'
{
  "password" : "px_writer_passwd",
  "roles" : [ "writer"],
  "full_name" : "writer",
  "email" : "writer@example.com"
}'
```

## 常见问题
- no test named 'eq'
> python -m pip install -U jinja2

# Beats
> 支持 rpm 或 dpkg 包管理器
> 其中 CentOS 需要 6+ 以上系统

1.在 hosts 中添加主机地址, 例如:
[example]
192.168.1.1
192.168.1.2
192.168.1.3
> example 为组名，建议使用项目名

2.添加配置文件：
在 files/configures/ 目录下添加 filebeat-example.yml
> example 为组名，建议使用项目名

3.部署并配置 beats:
ansible-playbook -i hosts beats-setup.yml -e hosts=example
> hosts=example 修改为上面使用的组名, 如需部署所有组，则使用 hosts=all


4.重新下发配置(不进行安装):
ansible-playbook -i hosts beats-full-reconfigure.yml -e hosts=example
> hosts=example 修改为上面使用的组名, 如需部署所有组，则使用 hosts=all
