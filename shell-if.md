

### 文件目录判定

```
-e filename  如果 filename存在,则为真  [ -e /var/log/syslog ]
-d filename  如果 filename为目录,则为真  [ -d /tmp/mydir ]
-f filename  如果 filename为常规文件,则为真  [ -f /usr/bin/grep ]
-L filename  如果 filename为符号链接,则为真  [ -L /usr/bin/grep ]
-r filename  如果 filename可读,则为真  [ -r /var/log/syslog ]
-w filename  如果 filename可写,则为真  [ -w /var/mytmp.txt ]
-x filename  如果 filename可执行,则为真  [ -L /usr/bin/grep ]
-s filename　如果 filename文件大小非0时为
filename1-nt filename2  如果 filename1比 filename2新,则为真  [ /tmp/install/etc/services -nt /etc/services ]
filename1-ot filename2  如果 filename1比 filename2旧,则为真  [ /boot/bzImage -ot arch/i386/boot/bzImage ]
```
### 字符串比较运算符

(请注意引号的使用,这是防止空格扰乱代码的好方法)
```
-z string  如果 string长度为零,则为真  [ -z "$var" ]
-n string  如果 string长度非零,则为真  [ -n "$var" ]
如果 string1与 string2相同,则为真  [[ "$var" = "one two three" ]]
如果 string1与 string2不同,则为真  [[ "$var" != "one two three" ]]
如果 string2是 string1的一部分,则为真  [[ "$var" =~ "one two three" ]]
如果 string2是 string1的一部分,则为真  [[ "$var" = "*one two three*" ]]
```
### 算术比较运算符
```
num1-eq num2  等于 [ 3 -eq $mynum ]
num1-ne num2  不等于 [ 3 -ne $mynum ]
num1-lt num2  小于 [ 3 -lt $mynum ]
num1-le num2  小于或等于 [ 3 -le $mynum ]
num1-gt num2  大于 [ 3 -gt $mynum ]
num1-ge num2  大于或等于 [ 3 -ge $mynum ]
```

### 例子

1:判断目录`$dir`是否存在,若不存在,则新建一个

```shell
if [ ! -d "$dir"]; then
  mkdir "$dir"
fi
```

2:判断普通文件`$file`是否存,若不存在,则新建一个
```shell
if [ ! -f "$file" ]; then
  touch "$file"
fi
```

3:判断`$sh`是否存在并且是否具有可执行权限
```shell
if [ ! -x "$sh"]; then
    chmod +x "$sh"
fi
```

4:是判断变量`$var`是否有值
```shell
if [ ! -n "$var" ]; then
　　echo "$var is empty"
　　exit 0
fi
```

判断数字
```shell
if [[ ! "${TARGET_TIME}" =~ ^[1-9][0-9]*$ ]]; then
  echo
  echo "Invaild input..."
  echo
  display_help
  exit 1
fi
```