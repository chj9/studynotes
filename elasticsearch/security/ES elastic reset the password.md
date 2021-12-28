### 参考
https://discuss.elastic.co/t/i-lost-the-password-that-has-been-changed/91867/2
### Reseting the password for the elastic user
To do this, you need to create an alternate superuser and then authenticate as that user in order to change the password for elastic. This requires a number of steps.  
1. Stop your elasticsearch node
2. Ensure that the file realm is available on your elasticsearch node. If you are using a default X-Pack configuration for authentication, then the file realm is available and you don't need to do anything. However, if you have explicitly configured the authentication realms 332 in your elasticsearch.yml file, then you need to add a file realm 391 to the list of realms.
3. Use the bin/x-pack/users command to create a new file-based 198 superuser:
bin/x-pack/users useradd my_admin -p my_password -r superuser
4. Start your elasticsearch node
5. Using curl, reset the password 245 for the elastic user:
```shell
curl -u my_admin -XPUT 'http://localhost:9200/_xpack/security/user/elastic/_password?pretty' -H 'Content-Type: application/json' -d'
{
   "password" : "new_password"
}
```
6. Verify the new password  
`curl -u elastic 'http://localhost:9200/_xpack/security/_authenticate?pretty'`  
7. If you wish, stop elasticsearch and then remove the file realm from your elasticsearch.yml and/or remove 113 the my_admin user from the file realm.