## 描述: SCP命令



scp [参数] [原路径] [目标路径]

Case 1: 将本地文件发送到远端
```shell
scp local_file remote_username@remote_ip:remote_file
scp -i key.pem local_file remote_username@remote_ip:remote_file
```

Case 2: 将本地文件夹发送到远端, 递归模式 `-r`

```shell
scp -r local_folder remote_username@remote_ip:remote_folder
scp -i key.pem -r local_folder remote_username@remote_ip:remote_folder
```

Case 3: 啰嗦模式 `-v`,检查错误的好方法
```shell
scp -v ~/123.txt username@remote_ip:/home/ubuntu/456.txt
```

Case 4: 多个文件之间用空格隔开
```shell
scp 123.txt 456.txt username@remote_ip:/home/ubuntu/directory/
```

Case 5: 两个远程主机之间复制文件
```shell
scp user1@remotehost1:/some/remote/dir/foobar.txt user2@remotehost2:/some/remote/dir/
```
Case 6: 压缩复制文件
```shell
scp -vrC ~/Downloads root@192.168.1.3:/root/Downloads
```

