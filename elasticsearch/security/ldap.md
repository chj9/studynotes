### ldap调试命令：
```shell
ldapsearch -x -D "cn=username, ou=people, dc=example, dc=com" -w password -b "dc=example,dc=com" -p 389 -h ldap.example.com
```
-D: bind_dn  
-w: 密码  
-b: base_dn  
-h: 连接的host  
-p: 端口号 

### elasticsearch.yml 修改
order 数值越小越优先, ES7.X版本文档的配置项稍有不同，下面这个是6.X的配置，应该是兼容的
```yaml
xpack:
  security:
    authc:
      realms:
        ldap1:
          type: ldap
          order: 0
          url: "ldap://ldap.example.com:389"
          bind_dn: "cn=username, ou=people, dc=example, dc=com"
          bind_password: password
          user_search:
            base_dn: "dc=example,dc=com"
            filter: "uid={0}"
          unmapped_groups_as_roles: false
        native1:
          type: native
          order: 1
```