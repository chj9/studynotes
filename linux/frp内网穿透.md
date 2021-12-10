# 目的
实现开发人员在外网也能访问公司内网测试环境
文档（需要科学上网才能访问）
https://gofrp.org/docs/
# 准备
1Core 1G 云服务器
# 操作步骤
## 服务端配置
**1. 执行以下命令**
拉取镜像
`docker pull snowdreamtech/frps:0.37.0`

创建安装文件夹
`mkdir /opt/frp/`

创建配置
```
cat >/opt/frp/frps.ini <<EOF
[common]
bind_port = 7000
authentication_method = token
token = qIslNnGPrbXpPBo8iS1DZ5Gv9lFONJUe
#下面是dashboard，不需要可以注释
dashboard_port = 7500
# dashboard 用户名密码是 admin，按需要修改
dashboard_user = admin
dashboard_pwd = admin
EOF
```

**2.执行命令启动frp**
`docker run -itd --restart=always --network host -v /opt/frp/frps.ini:/etc/frp/frps.ini --name frps snowdreamtech/frps:0.37.0`

3.测试访问dashboard浏览器访问 **云服务器IP:7500**

## 客户端配置
选一台内网IP做
拉取镜像
`docker pull snowdreamtech/frpc:0.37.0`

创建安装文件夹
`mkdir /opt/frp/`

创建配置
```
cat >/opt/frp/frpc.ini <<EOF
[common]
# 如果过没有域名直接写公网ip也可以
server_addr = 云服务器IP
server_port = 7000
token = qIslNnGPrbXpPBo8iS1DZ5Gv9lFONJUe

[ssh]
type = tcp
local_ip = 172.17.20.45
local_port = 22
remote_port = 6000
use_encryption = true
use_compression = true

[sqlserver]
type = tcp
local_ip = 172.17.20.45
local_port = 1430
remote_port = 6001
use_encryption = true
use_compression = true

[es]
type = tcp
local_ip = 172.17.20.45
local_port = 9200
remote_port = 6002
use_encryption = true
use_compression = true

EOF
```
同理redis，es等都是tcp连接
**2.执行命令启动frp**
`docker run -itd --restart=always --network host -v /opt/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc:0.37.0`

##  测试访问内网虚拟机
比如我想访问ES,其他类似
**curl  外网IP:6002 **

## 安全地暴露内网服务
避免公网IP被扫描到之后，通过公网跳板对内网服务做破坏
### 内网端
在需要暴露到内网的机器上部署 frpc，且配置如下：
```
[common]
server_addr = 云服务器IP
server_port = 7000
token = qIslNnGPrbXpPBo8iS1DZ5Gv9lFONJUe

[secret_es]
type = stcp
# 只有 sk 一致的用户才能访问到此服务
sk = abcdefg
local_ip = 127.0.0.1
local_port = 9200
```
### 用户端
在想要访问内网服务的机器上也部署 frpc，且配置如下：
```
[common]
server_addr = 云服务器IP
server_port = 7000
token = qIslNnGPrbXpPBo8iS1DZ5Gv9lFONJUe

[secret_ssh_visitor]
type = stcp
# stcp 的访问者
role = visitor
# 要访问的 stcp 代理的名字
server_name = secret_es
sk = abcdefg
# 绑定本地端口用于访问服务
bind_addr = 127.0.0.1
bind_port = 6002
```
> 注意： visitor 中配置的  `sk`  和  `server_name`  必须与内网服务器上的 frpc 的配置一致， 而且  `bind_ip`  只能是  `127.0.0.1`