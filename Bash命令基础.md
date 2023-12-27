

## 描述: 基础代码的基础示例



### umask
存储在/etc/profile
```shell
$ umask
0022
$ umask -S
```

### cp
```shell
# -i 复制前如果存在同名文件则询问
cp -i source destination
cp -R -i source/ destination
```

### ln链接文件
```shell
# -s 软连接,软链接和源文件不是同一个,文件大小不同,软链接存在断链的危险
ln -s data_file sl_data_file

# 没有参数,硬链接
$ ln code_file hl_code_file
# inode数量+1,硬链接文件和源文件是同一个,硬链接只能在同一个设备创建
$ ls -il  
13058 -rwx - - - - - - 1 longcheng longcheng 48 8月 5 16:38 file1  
13059 -rwx - - - - - - 2 longcheng longcheng 57 8月 5 16:40 file2  
13059 -rwx - - - - - - 2 longcheng longcheng 57 8月 5 16:40 file2hard  
```

### rm
```shell
# -i 删除前询问
rm -i file
rm -i f?ll
rm -i f[1-5]ll
rm -r folder/
rm -ri folder/
rm -rf folder/
```

### mkdir
```shell
mkdir test{1,2,3,4,5}
mkdir -p t{1,2,3,4,5}/{a,b,c}
```

### 查看文件
```shell
less file
cat -n file
head -n 5 file
tail -n 5 file
# 倒数第五行和第四行
tail -n 5 123 | head -n 2

# 持续查看
tail -f a.log
```

### 文件信息

```shell
stat test.sh
```

### 查看所有已挂载磁盘的使用情况

```shell
# 查看所有已挂载磁盘的使用情况,包含已删除文件和临时文件
# 剩余空间是准确的
$ df -h

# 查看当前目录大小
$ du -sh .

# 查看当前文件夹中文件大小并排序
# 文件大小是准确的
$ du -sh * | sort -hr
```

### sort排序
```shell
$ sort -n  # 按数值大小进行排序
$ sort -M # 在日志中,按月份进行排序

# 使用-t做分隔符,-k参数来指定排序的字段
$ sort -t ':' -k 3 -n /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
bin:x:1:1:bin:/bin:/sbin/nologin 
daemon:x:2:2:daemon:/sbin:/sbin/nologin 
adm:x:3:4:adm:/var/adm:/sbin/nologin 
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin 
sync:x:5:0:sync:/sbin:/bin/sync 
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown 
halt:x:7:0:halt:/sbin:/sbin/halt 
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin 
news:x:9:13:news:/etc/news: 
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin 
operator:x:11:0:operator:/root:/sbin/nologin
```


### 压缩和解压缩
注意分清楚压缩文件和打包文件并不是同一个概念,和Windows不同
```shell
# zip文件
$ zip test.zip 1.txt 2.txt
$ unzip -d /tmp/ test.zip # 指定解压位置

# gz文件
$ gzip 1.txt # 压缩文件,源文件会消失
$ gzcat # 查看压缩文件
$ gunzip test.gz # 解压文件
$ gzip -d test.gz # 解压文件

# bz文件
$ bzip2 -k 1.txt # 压缩
$ bzip2 -d 1.txt.bz # 解压
$ bunzip2 1.txt.bz # 解压
```

### 归档和解包数据
```shell
# 压缩文件 -c create -v verbose -z gzip压缩 -f 指定文件
tar -czvf test1.tar.gz h1.html h2.html

# 列出归档中的文件不解包 -t list
tar -tf test1.tar 

# 列出归档中的文件不解压缩包 -t list
tar -tzvf test1.tar 

# 解压并解包数据 
tar -zxvf test1.tar.gz

# 单独解压文件 
tar -zxvf test1.tar.gz -C /tmp h1.html

# bz2压缩
tar -cjvf test1.tar.gz h1.html h2.html

# bz2解压缩
tar -zjvf test1.tar.gz h1.html h2.html
```

### 后台进程
生成子shell的成本不低,而且速度还慢。创建嵌套子shell更是火上浇油!
```shell
# 创建备份文件是有效利用后台进程列表的一个实用的例子
$ (tar -cf Rich.tar /home/rich ; tar -cf My.tar /home/christine)&

# 协程,My_Job是协程的名字
$ coproc My_Job { sleep 10; }

$ jobs -l
```

### w、who、last、lastlog
```shell
$ w
 02:46:53 up 7 min,  2 users,  load average: 0.00, 0.01, 0.02
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     tty1                      02:40    6:37   0.01s  0.01s -bash
root     pts/0    192.168.28.131   02:43    5.00s  0.01s  0.00s w

$ who
root     tty1         2021-03-25 02:40
root     pts/0        2021-03-25 02:43 (192.168.28.131)

$ last
root     pts/0        192.168.28.131   Thu Mar 25 02:43   still logged in   
root     tty1                          Thu Mar 25 02:40   still logged in   
reboot   system boot  3.10.0-1160.15.2 Thu Mar 25 02:39 - 02:44  (00:04)    
root     pts/0        192.168.0.101    Mon Mar 22 09:13 - 09:23  (00:10)    
root     tty1                          Mon Mar 22 09:12 - 02:39 (2+17:27)  

$ lastlog
用户名           端口     来自             最后登陆时间
root             pts/0    192.168.28.131   四 3月 25 02:43:38 -0400 2021
bin                                        **从未登录过**
daemon                                     **从未登录过**
adm                                        **从未登录过**
```

### mount
/etc/fstab
```shell

# 挂载光盘 /dev/cdrom > /dev/sr0
$ mkdir /mnt/cdrom && mount -t iso9660 /dev/cdrom /mnt/cdrom
$ umunt /mnt/cdrom

# 挂载U盘
# u盘名字是不确定的,需要先查询 fdisk -l
$ mkdir /mnt/usb && mount -t vfat /dev/sdb1 /munt/usb


```

### /etc/passwd文件
```
root:x:0:0:root:/root:/bin/bash
```
* 登录用户名
* 用户密码
* 用户账户的UID(数字形式)
* 用户账户的组ID(GID)(数字形式) 
* 用户账户的文本描述(称为备注字段) 
* 用户HOME目录的位置
* 用户的默认shell

### /etc/shadow文件
```
rich:$1$.FfcK0ns$f1UgiyHQ25wrB/hykCn020:11627:0:99999:7:::
```
* 与/etc/passwd文件中的登录名字段对应的登录名
* 加密后的密码
* 自上次修改密码后过去的天数密码(自1970年1月1日开始计算) 
* 多少天后才能更改密码
* 多少天后必须更改密码
* 密码过期前提前多少天提醒用户更改密码
* 密码过期后多少天禁用用户账户
* 用户账户被禁用的日期(用自1970年1月1日到当天的天数表示) 
* 预留字段给将来使用

### /etc/group文件
```shell
root:x:0:root
```
* 组名
* 组密码
* GID
* 属于该组的用户列表
组密码允许非组内成员通过它临时成为该组成员。这个功能并不很普遍,但确实存在.千万不能通过直接修改/etc/group文件来添加用户到一个组,要用usermod命令.
当一个用户在/etc/passwd文件中指定某个组作为默认组时, 用户账户不会作为该组成员再出现在/etc/group文件中


### 用户命令
```shell
# 添加用户
$ adduser elephant 
# 修改密码
$ passwd elephant
# 强制用户下次登录时修改密码
$ passwd -e elephant
# chpasswd可以批量修改用户密码
$ chpasswd < users.txt
$ cat users.txt
user1:passwd1
user2:passwd2

# 修改用户shell,必须用shell的全路径名作为参数,不能只用shell名
$ chsh -s /bin/bash elephant

# 修改用户的备注信息
$ chfn elephant
# 设置账户被禁用的日期
$ chage -E 2021-02-05 -I 0 elephant
# 添加到sudo组 -g 会改变用户的基本组慎用
$ usermod -aG sudo elephant
# 锁定用户
$ usermod -L elephant
# 解锁用户
$ usermod -U elephant
# 连同家目录一起删除,注意检查是否有重要文件
$ deluser -r elephant
# 查看用户
$ cat /etc/passwd
```

### 组命令
```shell
# 添加组
$ addgroup share
# 指定组ID
$ addgroup -g 2000 share
# 删除组
$ delgroup share
# 查看组
$ cat /etc/group
```

### umask
对文件来说,全权限的值是666(所有用户都有读和写的权限);而对目录来说,则是777(所有用户都有读、写、执行权限)。u这些默认权限是通过“umask”权限掩码控制的。一般默认的umask值为022,其最终效果就是新创建的目录权限为755,文件权限为644。所以只要修改了用户的umask值,就可以控制默认权限。

对目录没有读权限则无法列出目录中的文件,没有执行权限则无法列出目录内文件详情


### chown
```shell
$ chown ubuntu:test file.txt
# 同时改变属主属组
$ chown test. file.txt
# 仅改变属组
$ chown .test file.txt
```

### chgrp
```shell
$ chgrp groupName file
```

### chmod
```shell
chmod +x filename

chmod [ugoa...][[+-=][rwxXstugo...]
# u代表用户
# g代表组
# o代表其他
# a代表上述所有

# X:如果对象是目录或者它已有执行权限,赋予执行权限
# s:运行时重新设置UID或GID
# t:保留文件或目录
# u:将权限设置为跟属主一样
# g:将权限设置为跟属组一样
# o:将权限设置为跟其他用户一样
chmod u-x newfile # 移除属主的执行权限
```

### 特殊权限
```shell
$ mkdir testdir
$ ls -l
drwxrwxr-x 2 rich rich 4096 Sep 20 23:12 testdir/
$ chgrp shared testdir 
$ chmod g+s testdir
$ ls -l
drwxrwsr-x 2 rich shared 4096 Sep 20 23:12 testdir/
$ umask 002
$ cd testdir
$ touch testfile
$ ls -l
total 0
-rw-rw-r-- 1 rich shared 0 Sep 20 23:13 testfile

```
首先,用mkdir命令来创建希望共享的目录。然后通过chgrp命令将目录的默认属组改为包 含所有需要共享文件的用户的组(你必须是该组的成员)。最后,将目录的SGID位置位,以保证 目录中新建文件都用shared作为默认属组。
为了让这个环境能正常工作,所有组成员都需把他们的umask值设置成文件对属组成员可 写。在前面的例子中,umask改成了002,所以文件对属组是可写的。
做完了这些,组成员就能到共享目录下创建新文件了。跟期望的一样,新文件会沿用目录的 属组,而不是用户的默认属组。现在shared组的所有用户都能访问这个文件了。

### 文件系统
fdisk /dev/sdb
mkfs.ext4 /dev/sdb1

#### 逻辑卷管理
physical volume,PV
volume group,VG
logical volume,LV

### rpm

```shell
rpm -qa httpd # 查询本机安装的包
rpm -qip /mnt/cdrom/httpd-XX.rpm # 查看未安装包的信息
rpm -ql httpd # 查看软件包相关文件的位置
rpm -qf /etc/httpd/conf # 查看文件属于哪个包
rpm -ivh XXX.rpm # i install,v verbose, h process
rpm -Uvh XXX.rpm # 安装并升级
rpm --force -ivh XXX.rpm # 强制重装,误删文件
rpm --test XXX.rpm # 测试依赖
rpm -e --nodeps XXX.rpm # 卸载本体和依赖
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 # 导入证书
rpm --qa | grep gpg # 查看证书
```

### yum
/etc/yum.repos.d
```shell
yum list installed
yum list installed > installed_software

yum localinstall package_name.rpm # 本地安装
yum list updates # 列出所有已安装包的可用更新
yum update package_name # 升级包

# 只删除软件包而保留配置文件和数据文件
yum remove package_name 
#要删除软件和它所有的文件
yum erase package_name

# 显示包的依赖关系
yum deplist package_name

# 查看现在正从哪些仓库中获取软件
yum repolist

yum grouplist
yum groupinstall pkggroup # 安装包组
yum groupremove pkggroup # 卸载包组
```



### 重定向

#### 分别重定向
```shell
$ ls -al test test2 test3 badtest 2> error.log 1> normal.log 
$ cat error.log
ls: cannot access test: No such file or directory 
ls: cannot access badtest: No such file or directory 
$ cat normal.log 
-rw-rw-r-- 1 rich rich 158 2014-10-16 11:32 test2 -rw-rw-r-- 1 rich rich 0 2014-10-16 11:33 test3
```

#### 特殊重定向 &>
```shell
$ ls -al test test2 test3 badtest &> test7
$ cat test7
ls: cannot access test: No such file or directory 
ls: cannot access badtest: No such file or directory  # badtest错误跑到了第二行,理论应该在第四行
-rw-rw-r-- 1 rich rich 158 2014-10-16 11:32 test2 
-rw-rw-r-- 1 rich rich 0 2014-10-16 11:33 test3
```
为了避免错误信息散落在输出文件中,相较于标准输出,bash shell自动赋予了错误消息更高的优先级。这样能够集中浏览错误信息。

#### 特意重定向
这里将正常输出重定向到STDERR
```shell
echo "This is an error" >&2  #特意将输出变为STDERR
```

#### 永久重定向
在脚本中添加 `exec 1>testout` 让脚本中所有的输出都重定向到testout
```shell
#!/bin/bash
# redirecting all output to a file
exec 1>testout
```
同理也有其他文件描述符的重定向
```shell
exec 3>test13out
echo "This should display on the monitor"
echo "and this should be stored in the file" >&3
```
示例
```shell
$ cat test11
#!/bin/bash
# redirecting output to different locations
exec 2>testerror
echo "This is the start of the script"
echo "now redirecting all output to another location"
exec 1>testout
echo "This output should go to the testout file" echo "but this should go to the testerror file" >&2 $
$ ./test11
This is the start of the script
now redirecting all output to another location
$ cat testout
This output should go to the testout file
$ cat testerror
but this should go to the testerror file
```
#### 输入重定向

用来处理日志文件很有帮助
```shell
 cat test12
#!/bin/bash
# redirecting file input
exec 0< testfile
count=1
while read line
do
   echo "Line #$count: $line"
   count=$[ $count + 1 ]
done
$ ./test12
Line #1: This is the first line. 
Line #2: This is the second line. 
Line #3: This is the third line.
```


### netstat
安装net-tools
```shell
netstat -an ｜ grep "ESTABLISHED" | wc -l # 查看网络连接数
```
