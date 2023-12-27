# 脚本初始

## 用户家目录获取

```shell
echo $HOME

env|grep ^HOME=|cut -c 6-
```

## 脚本参数设置
```shell
$ cat options.sh
#!/bin/bash
# extracting command line options as parameters #
echo
while [ -n "$1" ]
do
  case "$1" in
    -a) echo "Found the -a option" ;;
    -b) echo "Found the -b option" ;;
    -c) echo "Found the -c option" ;;
    *) echo "$1 is not an option" ;;
  esac
  shift #用于移除参数
done

$ ./options.sh -a -b -c -d
Found the -a option 
Found the -b option 
Found the -c option 
-d is not an option
```

```shell
function usage() {
  echo "Usage:
  ./$0 \\
    -a <word> \\
    -b [say something] \\
    -h [get help]

Example:
  $0 -a word -b
  $0 -h to get help
"
  exit 0
}

# :表示选项后面必须带有参数
while getopts "a:bh" opt; do
  case "$opt" in
  a) WORD="$OPTARG" ;;
  b) echo "I am the best";;
  h) usage ;;
  \?) echo "Invalid parameter"; usage; return 1;;
  esac
done

echo "Hello ${WORD}"
```

## 脚本参数设置2

```bash
#!/bin/bash
start() {
echo "Starting vnc server with $resolution on Display $display"
#your execute command here mine is below
#vncserver :$display -geometry $resolution
}

stop() {
echo "Killing vncserver on display $display"
#vncserver -kill :$display
}

#########################
# The command line help #
#########################
display_help() {
    echo "Usage: $0 [option...] {start|stop|restart}" >&2
    echo
    echo "   -r, --resolution           run with the given resolution WxH"
    echo "   -d, --display              Set on which display to host on "
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}

################################
# Check if parameters options  #
# are given on the commandline #
################################
while :
do
    case "$1" in
      -r | --resolution)
          if [ $# -ne 0 ]; then
            resolution="$2"   # You may want to check validity of $2
          fi
          shift 2
          ;;
      -h | --help)
          display_help  # Call your function
          exit 0
          ;;
      -d | --display)
          display="$2"
           shift 2
           ;;

      -a | --add-options)
          # do something here call function
          # and write it in your help function display_help()
           shift 2
           ;;

      --) # End of all options
          shift
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          ## or call function display_help
          exit 1 
          ;;
      *)  # No more options
          break
          ;;
    esac
done

###################### 
# Check if parameter #
# is set too execute #
######################
case "$1" in
  start)
    start # calling function start()
    ;;
  stop)
    stop # calling function stop()
    ;;
  restart)
    stop  # calling function stop()
    start # calling function start()
    ;;
  *)
#    echo "Usage: $0 {start|stop|restart}" >&2
     display_help

     exit 1
     ;;
esac
```

#### 变量设置

定义变量,变量区分大小写,变量也会被覆盖,默认是global
```shell
variable=value      # 定义变量
myvar="hello world" # 如果变量的值包含空格,则必须将值放在引号中
e=$(ls -l foo.txt)  # 变量值可以是命令的执行结果
foo=1;bar=2         # 定义多个变量
local a=5           # 定义在函数内,作用域只在当前函数
```




#### 绝对路径

如果仅仅是到脚本所在的相对目录,下面的就可以:
```shell
cd $(dirname $0)
```
dirname $0是获取脚本所在的目录。

如果要获取执行脚本所在目录的绝对路径,可以用下面的方法:
```shell
script_dir=$(cd $(dirname $0) && pwd -P)
script_dir=$(dirname $(readlink -f $0 ))
#pwd -P可以获取当前目录的绝对路径,并且如果当前目录只是一个软链接,它所显示得是链接目标的绝对路径。

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
```

## 脚本处理

#### 默认变量处理
```shell
varname=${varname:-word}	# 如果变量varname存在且不为空,则返回它的值,否则返回word
varname=${varname:=word}	# 如果变量varname存在且不为空,则返回它的值,否则将它设为word,并且返回word
varname=${varname:+word}	# 如果变量名存在且不为空,则返回word,否则返回空值。
${varname:?message}	# 如果变量varname存在且不为空,则返回它的值,否则打印出varname: message,并中断脚本的执行
parameter=${1:?"parameter missing."} # 如果参数1不存在,就退出脚本并报错。
```

#### 数组变量处理
```shell
# 数组变量初始化
array[0]=a
array[1]=b
array=(a b c d)     # 数组变量
files=($(ls *.txt)) # 数组变量

array+=(d e f)  # 追加数组成员


# 循环数组变量
for i in "${array[@]}"; do
  echo ${i}
done

echo ${array[@]} #输出变量
```

#### 数学运算处理
```shell
var1=100
var2=50
var3=45
var4=$[$var1 * ($var2 - $var3)] echo The final result is $var4
```

#### 脚本日志处理

在脚本中输出并记录日志

```shell
LOG_FILE='/var/log/script_'$(date +"%Y-%m-%d_%H-%M-%S")'.log'

function write_log()
{
  now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
  echo ${now_time} $1 | tee -a ${log_file}
}

write_log "everything is ok"
```

在脚本中写入系统日志
```shell
logger -t ScriptName "Hello World"
```

#### 检查文件是否存在
```shell
#!/bin/bash
# Check if either a directory or file exists #
location=$HOME
file_name="sentinel"
#
if [ -e $location ]
then #Directory does exist
  echo "OK on the $location directory."
  echo "Now checking on the file, $file_name." #
  if [ -e $location/$file_name ]
  then #File does exist
    echo "OK on the filename"
    echo "Updating Current Date..." date >> $location/$file_name
  else #File does not exist
    echo "File does not exist"
    echo "Nothing to update"
  fi
else   #Directory does not exist
  echo "The $location directory does not exist."
  echo "Nothing to update"
fi
```

#### shell 执行命令失败则中断执行
```
Command || ! echo 'Something Wrong' || exit 1
```

#### 菜单

```shell
echo "Which Operating System do you like?"

select os in Ubuntu LinuxMint Windows8 Windows7 WindowsXP
do
  case $os in
    "Ubuntu"|"LinuxMint")
      echo "I also use $os."
      break
    ;;
    "Windows8" | "Windows7" | "WindowsXP")
      echo "Why don't you try Linux?"
      break
    ;;
    *)
      echo "Invalid entry."
      break
    ;;
  esac
done
```

#### 临时文件

`mktemp`命令可生成的临时文件名为随机值,且权限是只有用户本人可读写的临时文件
```shell
$ mktemp
/tmp/tmp.4GcsWSG4vj

$ ls -l /tmp/tmp.4GcsWSG4vj
-rw------- 1 ruanyf ruanyf 0 12月 28 12:49 /tmp/tmp.4GcsWSG4vj
```

Bash 脚本使用`mktemp`命令的用法如下.为了确保临时文件创建成功,`mktemp`命令后面最好使用 `OR`运算符(||),保证创建失败时退出脚本。
```shell
#!/bin/bash

TMPFILE=$(mktemp) || exit 1
echo "Our temp file is $TMPFILE"
```

参数

* -d: 参数可以创建一个临时目录。
* -p: 参数可以指定临时文件所在的目录。默认是使用$TMPDIR环境变量指定的目录,如果这个变量没设置,那么使用/tmp目录。
* -t: 参数可以指定临时文件的文件名模板,模板的末尾必须至少包含三个连续的X字符,表示随机字符,建议至少使用六个X。默认的文件名模板是tmp.后接十个随机字符。
```shell
$ TMPDIR=$(mktemp -d)
$ echo ${TMPDIR}
/tmp/tmp.Wcau5UjmN6

$ mktemp -p /home/ruanyf/
/home/ruanyf/tmp.FOKEtvs2H3

$ mktemp -t mytemp.XXXXXXX
/tmp/mytemp.yZ1HgZV
```

#### 执行时间

```shell
#!/bin/bash

startTime=$(date +%Y/%m/%d-%H:%M:%S)
startTime_s=$(date +%s)

endTime=$(date +%Y/%m/%d-%H:%M:%S)
endTime_s=$(date +%s)

sumTime=$[ $endTime_s - $startTime_s ]

echo "$startTime ---> $endTime" "Total:$(($sumTime/60))min $(($sumTime%60))s"
```

#### 
