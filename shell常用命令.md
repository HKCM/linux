
# shell常用命令

#### 写入文件
```shell
cat>>"${filename}"<<EOF
hello world
代码改变世界 Coding Changes the World
100 \$ 
她买了张彩票,中了3,300多万美元。
She bought a lottery ticket and won more than\$ 33 million.
EOF
```

#### 批量修改文件名

批量添加、删除、修改后缀

```shell
# 添加.bak后缀
$ find ./ -name "*.repo" | while read id; do mv $id ${id}.bak; done

# 移除.bak后缀
for i in `ls | grep .bak`; do mv $i `echo "$i" | awk -F '.bak' '{print $1}'`;done

# a_finished.jpg -> a.jpg
for file_name in `ls *fin*jpg`; do mv $file_name `echo ${file_name//_finished/}`;done

for file_name in $(find ./ -name "*.repo"); do mv $file_name `echo ${file_name//_finished/}`;done
```

#### 获取本机IP

```shell
curl icanhazip.com
curl ifconfig.me
curl http://checkip.amazonaws.com
wget http://ipecho.net/plain -O - -q

# EC2
curl http://169.254.169.254/latest/meta-data/local-ipv4 # Get private IPv4
curl http://169.254.169.254/latest/meta-data/public-ipv4 # Get public IPv4
```

#### 查域名对应的IP
```shell
dig @8.8.8.8 www.baidu.com +short
```

#### 下载文件

```shell
# 原名下载文件
curl -O https://cn.bing.com/th?id=OHR.GlassBridge_EN-CN9756315422_1920x1200.jpg
# 改名下载文件
curl -o GlassBridge.jpg https://cn.bing.com/th?id=OHR.GlassBridge_EN-CN9756315422_1920x1200.jpg
wget wget -O 1.jpg URL # 下载文件并改名
```

#### 连接时间
```shell
# -w:从文件中读取信息打印格式
# -o:输出的全部信息
# -s:不打印进度条
cat>curl_format.txt <<EOF
time_namelookup: %{time_namelookup}\t\t#Time from start until name resolving completed\n
time_connect: %{time_connect}\t\t#Time from start until remote host or proxy completed.\n
time_appconnect: %{time_appconnect}\t\t#Time from start until SSL/SSH handshake completed.\n
time_pretransfer: %{time_pretransfer}\t\t#Time from start until just before the transfer begins\n
time_redirect: %{time_redirect}\t\t#Time taken for all redirect steps before the final transfer.\n
time_starttransfer: %{time_starttransfer}\t\t#Time from start until just when the first byte is received.(Time to first byte,TTFB)\n
---\n
time_total: %{time_total}\n
EOF
curl -o /dev/null -w "@curl_format.txt" -s https://www.baidu.com
```

#### 时间输出

```shell
date +%F # 2023-11-23
date +%T # 15:51:44
date +"%Y-%m-%d %H:%M:%S" # 2023-11-23 22:20:02
# 时间时区
# /usr/share/zoneinfo/ 目录下
TZ="America/New_York" date +"%Y-%m-%d %H:%M:%S %z"
TZ="Japan" date +"%Y-%m-%d %H:%M:%S %z" # 2023-11-23 22:19:41 +0900
# 返回之后一小时 在Mac上不好使
date -d '+1 hour' +"%Y-%m-%d %H:%M:%S"
date -d "+15 minutes" "+%Y-%m-%d %H:%M:%S"
```