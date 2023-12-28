

# 描述: Bash基础入门

- [描述: Bash基础入门](#描述-bash基础入门)
  - [快捷键](#快捷键)
  - [基础](#基础)
    - [shell](#shell)
    - [Shebang 行](#shebang-行)
    - [脚本执行位置](#脚本执行位置)
    - [set](#set)
    - [分号](#分号)
    - [\&\& 和 ||](#-和-)
    - [`?`和`*`匹配](#和匹配)
    - [方括号匹配](#方括号匹配)
    - [大括号扩展](#大括号扩展)
    - [特别匹配](#特别匹配)
    - [引号和转义](#引号和转义)
  - [变量](#变量)
    - [查看环境变量](#查看环境变量)
    - [参数变量](#参数变量)
    - [输入变量](#输入变量)
    - [变量默认值](#变量默认值)
    - [变量声明](#变量声明)
    - [读取变量](#读取变量)
    - [数组变量](#数组变量)
    - [字符串变量](#字符串变量)
      - [字符串的长度](#字符串的长度)
      - [子字符串](#子字符串)
      - [搜索和替换](#搜索和替换)
    - [删除变量](#删除变量)
    - [输出变量](#输出变量)
    - [特殊变量](#特殊变量)
    - [数学运算](#数学运算)
    - [declare 命令](#declare-命令)
  - [逻辑处理](#逻辑处理)
    - [if 结构](#if-结构)
      - [文件和目录判定](#文件和目录判定)
      - [字符串比较运算符](#字符串比较运算符)
      - [算术比较运算符](#算术比较运算符)
    - [if-elif-else](#if-elif-else)
    - [case](#case)
    - [while](#while)
    - [until](#until)
    - [for...in循环](#forin循环)
    - [for循环](#for循环)
    - [break,continue](#breakcontinue)
    - [select](#select)
    - [shift](#shift)

## 快捷键
```
Tab:自动补全
Ctrl + r:	实现快速检索使用过的历史命令.
Ctrl + l:清除屏幕
Ctrl + a:跳到本行的行首
Ctrl + e:光标回到命令行尾。
Ctrl + u:删除当前光标前面的文字(还有剪切功能)
Ctrl + k:删除当前光标后面的文字(还有剪切功能)
Ctrl + w:删除当前光标前一个单词
Ctrl + y:粘贴
Ctrl + c:终止当前命令
Ctrl + d:删除当前字符,没有字符时会退出shell
ESC + f:移动光标到后一个单词
ESC + b:移动光标到前一个单词
```

## 基础

### shell

```shell
# 查看当前使用的 shell
echo $SHELL

# 查看安装的 shell
cat /etc/shells

# 更换Shell
chsh -s /bin/zsh
```

### Shebang 行

脚本的第一行通常是指定解释器,Bash 脚本的解释器一般是`/bin/sh`或`/bin/bash`

```bash
#!/bin/sh

#!/usr/bin/env bash
```

如果 Bash 解释器不放在目录`/bin`,脚本就无法执行了。为了保险,可以写成下面这样。
```bash
#!/usr/bin/env bash
```
通过环境变量寻找`bash`所在位置并执行

### 脚本执行位置

当写了一个经常使用的脚本时,可以在主目录新建一个`~/bin`子目录,专门存放可执行脚本,然后把`~/bin`加入`$PATH`。
```bash
export PATH=$PATH:~/bin
```
上面命令改变环境变量`$PATH`,将`~/bin`添加到`$PATH`的末尾。可以将这一行加到`~/.bashrc`文件里面,然后重新加载一次`.bashrc`,这个配置就可以生效了。
```
$ source ~/.bashrc
```
以后不管在什么目录,直接输入脚本文件名,脚本就会执行。
```
$ script.sh
```

### set
`set`命令用来修改子 Shell 环境的运行参数,即定制环境。一共有十几个参数可以定制,[官方手册](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)有完整清单,本章介绍其中最常用的几个。

```shell
set -u # 脚本中遇到未定义变量时报错并退出
set -x # 运行代码前先将代码输出,排错推荐

# 到 -e遇到管道命令时只有管道的最后命令成功-e就会认为成功
set -e # 返回值不为0时终止脚本
set -o pipefail # 解决-e的管道问题
```

如果命令可能失败,但是希望继续运行
```shell
command || true
# 或在某段代码前暂时关闭set -e
set +e
command1
command2
set -e
```

最后推荐,写脚本时
```shell
set -euxo pipefail
# 或
set -eux
set -o pipefail
```

### 分号
分号(`;`)是命令的结束符,使得一行可以放置多个命令,上一个命令执行结束后,再执行第二个命令。
```
# 例1
for i in `ls`;do 
    echo $i is file name\!;
done

# 例2
touch file; ls
```
例如for循环,例2中,Bash 先执行touch命令,执行完成后,再执行ls命令。

注意,使用分号时,第二个命令总是接着第一个命令执行,无论touch执行成功或失败。

### && 和 ||

`&&`和`||`可以处理命令之间的执行关系
```
ls && echo "Hello"
```
表示如果`ls`命令成功,才运行`echo`命令。
```
touch 123 || ls
```
表示如果`touch`命令运行失败,才运行`ls`命令,如果`touch`成功则不执行`ls`。

### `?`和`*`匹配

`?`匹配单个字符,`*`匹配任意数量的任意字符
```
$ ls ?.txt
1.txt 2.txt

$ ls *.txt
1.txt 2.txt 123.txt
```
注意,`*`不会匹配隐藏文件(以`.`开头的文件),即`ls *`不会输出隐藏文件。

如果要匹配隐藏文件,需要写成`.*`。

### 方括号匹配
匹配括号之中的任意一个字符。比如,[12345]可以匹配五个数字的任意一个。
```bash
$ ls [12345].txt
1.txt 2.txt

```

反向匹配,`[^abc]`或`[!abc]`表示匹配除了a、b、c以外的字符.
```bash
# 存在 111、123、222 三个文件
$ ls ?[!2]?
111
```

连续匹配`[0-9]`,`[a-z]`,`[A-Z]`,还有`[!1-9]`
```bash
$ ls demo[0-9].txt
demo1.txt demo3.txt
```

* [a-z]:所有小写字母。
* [a-zA-Z]:所有小写字母与大写字母。
* [a-zA-Z0-9]:所有小写字母、大写字母与数字。
* [abc]*:所有以a、b、c字符之一开头的文件名。
* program.[co]:文件program.c与文件program.o。
* BACKUP.[0-9][0-9][0-9]:所有以BACKUP.开头,后面是三个数字的文件名。

注意,如果需要匹配`[`字符,可以放在方括号内,比如`[[aeiou]`。如果需要匹配连字号`-`,只能放在方括号内部的开头或结尾,比如`[-aeiou]`或`[aeiou-]`

### 大括号扩展

```bash
# 例1,创建3个文件
$ touch {1,2,3}.txt

# 例2,创建9个文件夹
$ mkdir {1,2,3}/{1,2,3}

# 例3,嵌套扩展
$ touch 1.{j{p,pe}g,png}
1.jpeg  1.jpg   1.png

# 例4,for循环连用
for i in {1..4}
do
  echo $i
done

```


### 特别匹配

* [[:alnum:]]:匹配任意英文字母与数字
* [[:alpha:]]:匹配任意英文字母
* [[:blank:]]:空格和 Tab 键。
* [[:cntrl:]]:ASCII 码 0-31 的不可打印字符。
* [[:digit:]]:匹配任意数字 0-9。
* [[:graph:]]:A-Z、a-z、0-9 和标点符号。
* [[:lower:]]:匹配任意小写字母 a-z。
* [[:print:]]:ASCII 码 32-127 的可打印字符。
* [[:punct:]]:标点符号(除了 A-Z、a-z、0-9 的可打印字符)。
* [[:space:]]:空格、Tab、LF(10)、VT(11)、FF(12)、CR(13)。
* [[:upper:]]:匹配任意大写字母 A-Z。
* [[:xdigit:]]:16进制字符(A-F、a-f、0-9)。

```bash
# 列出所有以大写字母开头的文件
$ ls [[:upper:]]*
```

### 引号和转义
`'`单引号效力最强,会让一切转义失效保留原样。`"`双引号保留美元符号(`$`)、反引号(\`)和反斜杠(`\`)的效力
```bash
$ a=1

$ echo '$a'
$a

# 双引号使用变量
$ echo "$a"
1

# -e 参数转义
$ echo -e "a\tb"
a	b

# 反引号
$ echo "I'd say: \"hello!\""
I'd say: "hello!"
```

## 变量

### 查看环境变量
所有的环境变量名均使用大写字母,这是bash shell的标准惯例。如果是自己创建的局部变量或是shell脚本,请使用小写字母。变量名区分大小写。

在涉及用户定义的局部变量时坚持使用小写字母,这能够避免重新定义系统环境变量可能带来的灾难。

```shell
$ env
$ printenv
$ printenv HOME

# set命令会显示为某个特定进程设置的所有环境变量,包括局部变量、全局变量以及用户定义变量,并按顺序排序后输出
$ set 
```


修改,删除子shell中全局环境变量并不会影响到父shell中该变量的值
```shell
$ my_variable="I am Global now" 
$ export my_variable
$ echo $my_variable
I am Global now
$ bash
$ echo $my_variable
I am Global now

$ my_variable="Null"
$ echo $my_variable
Null
$ exit
exit

$ echo $my_variable 
I am Global now

# 删除环境变量,记住不要使用$
$ unset my_variable

# 修改PATH环境变量
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

$ PATH=$PATH:/home/christine/Scripts
$ echo $PATH 
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/christine/Scripts

# 将当前目录加入PATH
$ PATH=$PATH:.
```

### 参数变量

```
`$0`:脚本文件名,即script.sh。
`$1~$9`:对应脚本的第一个参数到第九个参数。
`$#`:参数的总数。
`$@`:全部的参数,参数之间使用空格分隔。
`$*`:全部的参数,参数之间使用变量$IFS值的第一个字符分隔,默认为空格,但是可以自定义。
```

```shell
$ cat options.sh
#!/usr/bin/env bash
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

  ./scripts/admin/deploy_infra.sh \\
    -c <CMR Number> \\
    -s <service> \\
    -b <brand> \\
    -e <environment/stage> \\
    -p <aws_profile> \\

Example:

  $0 -s slack -b rc -e dev -p int-developer
"
  exit 0
}

while getopts "c:s:b:e:p:h" opt; do
  case "$opt" in
  c) CMR="$OPTARG" ;;
  s) Service="$OPTARG" ;;
  b) Brand="$OPTARG" ;;
  e) Stage="$OPTARG" ;;
  p) AwsProfile="$OPTARG" ;;
  h) usage ;;
  [?]) usage ;;
  esac
done
```

### 输入变量


### 变量默认值
```
Bash 提供四个特殊语法,跟变量的默认值有关,目的是保证变量不为空。

${var:-word}	# 如果变量var存在且不为空,则返回它的值,否则返回word
${var:=word}	# 如果变量var存在且不为空,则返回它的值,否则将它设为word,并且返回word
${var:+word}	# 如果变量var存在且不为空,则返回word,否则返回空值。
${var:?message}	# 如果变量varname存在且不为空,则返回它的值,否则打印出varname: message,并中断脚本的执行
filename=${1:?"filename missing."} # 如果参数1不存在,就退出脚本并报错。


$echo ${JENKINS_VERSION:-2.7.4}
```

### 变量声明

定义变量
```shell
$ variable=value          # 定义变量
$ myvar="hello world"     # 如果变量的值包含空格,则必须将值放在引号中
$ e=$(ls -l foo.txt)      # 变量值可以是命令的执行结果
$ foo=1;bar=2             # 定义多个变量
```
注意,变量区分大小写,变量也会被覆盖

局部变量
```shell
local a=5                 # 定义在函数内,作用域只在当前函数
```

### 读取变量
```
$ a=1
$ echo log_${a}
log_1
```
如果变量的值本身也是变量,可以使用${!varname}的语法,读取最终的值。
```bash
$ a=SHELL
$ echo $a
SHELL
$ echo ${!a}
/bin/bash
```

### 数组变量

声明变量
```shell
$ array[0]=a
$ array[1]=b
$ array[2]=c
$ array[3]=d

$ array=(a b c d)

$ files=($(ls *.txt))

# 数组变量
$ mytest=(one two three four five)
$ echo ${mytest[*]}
one two three four five
$ echo ${mytest[2]} 
three
# 删除单个变量和全部变量
$ unset mytest[2]
$ unset mytest
```



读取数组元素
```shell
# 读取单个元素
$ echo ${array[1]}

# 读取所有元素元素
$ echo ${array[@]}

# 配合for循环读取所有元素,一定要放在双引号内,避免数组中元素有空格出现意料之外的结果
for i in "${array[@]}"; do
  echo ${i}
done
```

如果直接读取数组变量不带下标的话,会返回下标为0的元素

数组长度
```shell
${#array[@]}
${#array[*]}

# 字符串长度也是一样的语法格式
${#myval}
```

提取数组成员
```shell
# 从数组1号位置开始提取3个成员,原数组不变
${array[@]:1:3}

# 从数组1号位置开始提取后面所有成员,原数组不变
${array[@]:1}

array2=(${array[@]:1})
```

追加数组成员
```
$ foo=(a b c)
$ foo+=(d e f)
$ echo ${foo[@]}
a b c d e f
```


### 字符串变量
#### 字符串的长度

```shell
$ myPath=/home/cam/book/long.file.name
$ echo ${#myPath}
29
```

#### 子字符串

语法`${varname:offset:length}`返回变量`$varname`的子字符串,从位置`offset`开始(从0开始计算),长度为`length`
```shell
$ count=frogfootman
$ echo ${count:4:4}
foot
$ echo ${count:4}
footman

$ foo="This string is long."
$ echo ${foo: -5}
long.
$ echo ${foo: -5:2}
lo
$ echo ${foo: -5:-2}
lon

```

#### 搜索和替换
1. 字符串头部的模式匹配
```shell
# 如果 pattern 匹配变量 variable 的开头,
# 删除最短匹配(非贪婪匹配)的部分,返回剩余部分
${variable#pattern}

# 如果 pattern 匹配变量 variable 的开头,
# 删除最长匹配(贪婪匹配)的部分,返回剩余部分
${variable##pattern}

$ myPath=/home/cam/book/long.file.name

$ echo ${myPath#/*/}
cam/book/long.file.name

$ echo ${myPath##/*/}
long.file.name

# 示例:匹配文件名
$ path=/home/cam/book/long.file.name

$ echo ${path##*/}
long.file.name

# 示例:匹配替换
# 模式必须出现在字符串的开头
${variable/#pattern/string}

$ foo=JPG.JPG
$ echo ${foo/#JPG/jpg}
jpg.JPG
```
  如果匹配不成功,则返回原始字符串。
```shell
$ phone="555-456-1414"
$ echo ${phone#444}
555-456-1414
```
2. 字符串尾部的模式匹配
```shell
# 如果 pattern 匹配变量 variable 的结尾,
# 删除最短匹配(非贪婪匹配)的部分,返回剩余部分
${variable%pattern}

# 如果 pattern 匹配变量 variable 的结尾,
# 删除最长匹配(贪婪匹配)的部分,返回剩余部分
${variable%%pattern}

$ path=/home/cam/book/long.file.name

$ echo ${path%.*}
/home/cam/book/long.file

$ echo ${path%%.*}
/home/cam/book/long

# 示例:匹配目录
$ path=/home/cam/book/long.file.name

$ echo ${path%/*}
/home/cam/book

# 示例:匹配替换
# 模式必须出现在字符串的结尾
${variable/%pattern/string}

$ foo=JPG.JPG
$ echo ${foo/%JPG/jpg}
JPG.jpg
```

3. 任意位置的模式匹配
```shell
# 如果 pattern 匹配变量 variable 的一部分,
# 最长匹配(贪婪匹配)的那部分被 string 替换,但仅替换第一个匹配
${variable/pattern/string}

# 如果 pattern 匹配变量 variable 的一部分,
# 最长匹配(贪婪匹配)的那部分被 string 替换,所有匹配都替换
${variable//pattern/string}

$ path=/home/cam/foo/foo.name

$ echo ${path/foo/bar}
/home/cam/bar/foo.name

$ echo ${path//foo/bar}
/home/cam/bar/bar.name

# 示例:将分隔符从:换成换行符
$ echo -e ${PATH//:/'\n'}
/usr/local/bin
/usr/bin
/bin
...
```

4. 改变大小写
下面的语法可以改变变量的大小写。
```shell
# 转为大写
${varname^^}

# 转为小写
${varname,,}
下面是一个例子。

$ foo=heLLo
$ echo ${foo^^}
HELLO
$ echo ${foo,,}
hello
```

### 删除变量

删除数组和删除变量一样
```
$ unset NAME
# 或
$ NAME=''
```

删除数组单个元素会导致该元素为`''`,但不会减少数组长度

### 输出变量
用户创建的变量仅可用于当前 Shell,子 Shell 默认读取不到父 Shell 定义的变量。为了把变量传递给子 Shell,需要使用export命令。这样输出的变量,对于子 Shell 来说就是环境变量。

```
export NAME=value
```
子 Shell 如果修改继承的变量,不会影响父 Shell。

### 特殊变量
```
$?
```
为上一个命令的退出码,用来判断上一个命令是否执行成功。返回值是0,表示上一个命令执行成功；如果是非零,上一个命令执行失败。

```
$
```
为当前 Shell 的进程 ID,这个特殊变量可以用来命名临时文件。Like `LOGFILE=/tmp/output_log.$$`,有时也可以用来杀死自己

```
$_
```
为上一个命令的最后一个参数,也可以使用`esc + .`

```
$0
```
为当前 Shell 的名称(在命令行直接执行时)或者脚本名(在脚本中执行时)。


```shell
#  原样输出$
echo "The cost of the item is \$15"
```

### 数学运算
shell数学运算符只支持整数运算
```shell
#!/usr/bin/env bash
var1=100
var2=50
var3=45
var4=$[$var1 * ($var2 - $var3)] echo The final result is $var4
```
有一个bc计算器可以支持浮点数运算


### declare 命令
declare命令可以声明一些特殊类型的变量,为变量设置一些限制,比如声明只读类型的变量和整数类型的变量。
```shell
declare OPTION VARIABLE=value

# -a:声明数组变量。
# -f:输出所有函数定义。
# -F:输出所有函数名。
# -i:声明整数变量。
# -l:声明变量为小写字母。
# -p:查看变量信息。
# -r:声明只读变量。
# -u:声明变量为大写字母。
# -x:该变量输出为环境变量。

$ declare -x foo	# 等同于 export foo

$ declare -r bar=1	# 只读变量不可更改,不可unset

$ a=10;b=20
$ declare -i c=a*b	# 将参数声明整数变量以后,可以直接进行数学运算
$ echo ${c}
200

$ declare -l foo=“foo”	# 变量小写 Mac中不支持
$ declare -u bar="bar"	# 变量大写 Mac中不支持

$ declare -p a 		# 输出变量信息
declare -- a="10"

$ declare -f		# 输出当前环境的所有函数,包括它的定义。
$ declare -F		# 输出当前环境的所有函数,包括它的定义
```





## 逻辑处理

### if 结构
```
if commands; then
  commands
[elif commands; then
  commands...]
[else
  commands]
fi
```
if 还能与逻辑运算结合
```
# 使用否定操作符!时,最好用圆括号确定转义的范围 -a 
if [ ! \( $INT -ge $MIN_VAL -a $INT -le $MAX_VAL \) ]; then
    echo "$INT is outside $MIN_VAL to $MAX_VAL."
else
    echo "$INT is in range."
fi
```
AND运算:符号&&,也可使用参数-a。
OR运算:符号||,也可使用参数-o。
NOT运算:符号!。
#### 文件和目录判定
```
[ -e filename ]  如果 filename存在,则为真  [ -e /var/log/syslog ]
[ -d filename ]  如果 filename为目录,则为真  [ -d /tmp/mydir ]
[ -f filename ]  如果 filename为常规文件,则为真  [ -f /usr/bin/grep ]
[ -L filename ]  如果 filename为符号链接,则为真  [ -L /usr/bin/grep ]
[ -r filename ]  如果 filename可读,则为真  [ -r /var/log/syslog ]
[ -w filename ]  如果 filename可写,则为真  [ -w /var/mytmp.txt ]
[ -x filename ]  如果 filename可执行,则为真  [ -L /usr/bin/grep ]
[ filename1 -nt filename2 ] 如果 filename1比 filename2新,则为真  [ /tmp/install/etc/services -nt /etc/services ]
[ filename1 -ot filename2 ] 如果 filename1比 filename2旧,则为真  [ /boot/bzImage -ot arch/i386/boot/bzImage ]
```
#### 字符串比较运算符

请注意引号的使用,这是防止空格扰乱代码的好方法

`[[]]` 和 `[]`的区别是双括号内支持正则表达式, `=~`是正则比较运算符
```
[ string ] 如果string不为空(长度大于0),则判断为真 [ "${myvar1}" ]
[ -z string ] 如果 string长度为零,则为真  [ -z "${myvar1}" ]
[ -n string ] 如果 string长度非零,则为真  [ -n "${myvar1}" ]
[ string1 = string2 ] 如果 string1与 string2相同,则为真  [ "${myvar1}" = "${myvar2}" ]
[ string1 == string2 ] 如果 string1与 string2相同,则为真  [ "${myvar1}" == "${myvar2}" ]
[ string1 != string2 ] 如果 string1与 string2不同,则为真  [ "${myvar1}" != "${myvar2}" ]
[[ string1 =~ string2 ]] 如果 string2是 string1的一部分,则为真  [[ "${myvar1}" =~ "${myvar2}" ]]
[[ string1 = *string2* ]] 如果 string2是 string1的一部分,则为真  [[ "${myvar1}" =~ *"${myvar2}"* ]]
```

#### 算术比较运算符
```
[ num1 -eq num2 ] 等于 [ 3 -eq ${mynum} ]
[ num1 -ne num2 ] 不等于 [ 3 -ne ${mynum} ]
[ num1 -lt num2 ] 小于 [ 3 -lt ${mynum} ]
[ num1 -le num2 ] 小于或等于 [ 3 -le ${mynum} ]
[ num1 -gt num2 ] 大于 [ 3 -gt ${mynum} ]
[ num1 -ge num2 ] 大于或等于 [ 3 -ge ${mynum} ]
```

### if-elif-else
```shell
#!/usr/bin/env bash
# Testing nested ifs - use elif & else #
testuser=NoSuchUser
#
if grep $testuser /etc/passwd
then
    echo "The user $testuser exists on this system." #
elif ls -d /home/$testuser then
    echo "The user $testuser does not exist on this system."
    echo "However, $testuser has a directory." #
else
    echo "The user $testuser does not exist on this system." echo "And, $testuser does not have a directory."
fi
```

### case
```shell
case expression in
  pattern | pattern2)
    commands ;;
  pattern )
    commands ;;
  * )
    commands ;;
esac
```
case的匹配模式可以使用各种通配符,下面是一些例子。

* a):匹配a。
* a|b):匹配a或b。
* [[:alpha:]]):匹配单个字母。
* ???):匹配3个字符的单词。
* *.txt):匹配.txt结尾。
* *):匹配任意输入,通过作为case结构的最后一个模式。

```Shell
#!/usr/bin/env bash

read -r -p "Are You Sure? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
		echo "Yes"
		;;
    [nN][oO]|[nN])
		echo "No"
       	;;
    *)
		echo "Invalid input..."
		exit 1
		;;
esac
```

### while
```
#!/usr/bin/env bash

number=0
while [ "$number" -lt 10 ]; do
  echo "Number = $number"
  number=$((number + 1))
done
```

批量创建用户
```shell
$ cat users.csv
rich,Richard Blum 
christine,Christine Bresnahan 
barbara,Barbara Blum 
tim,Timothy Bresnahan

#!/usr/bin/env bash
input=users.csv

while IFS=',' read -r userid name
do
  echo "adding $userid"
  useradd -c $name -m $userid
done < "$input"
```

### until

until循环与while循环恰好相反,只要不符合判断条件(判断条件失败),就不断循环执行指定的语句。一旦符合判断条件,就退出循环。
```
#!/usr/bin/env bash

number=0
until [ "$number" -ge 10 ]; do
  echo "Number = $number"
  number=$((number + 1))
done
```

### for...in循环
```
for i in $(ls *.md); do
  echo $i
done
```

### for循环
```shell
for (( i=0; i<5; i=i+1 )); do
  echo $i
done
```

```shell
#!/usr/bin/env bash
    # basic for command
for test in Alabama Alaska Arizona Arkansas California Colorado
do
  echo The next state is $test
done
```

遍历目录
```shell
for file in /home/rich/test/*
do
if [ -d "$file" ] then
  echo "$file is a directory" 
elif [ -f "$file" ]
then
  echo "$file is a file"
fi
done
```

查找$PATH中的可执行文件
```shell
#!/usr/bin/env bash
# finding files in the PATH
IFS=: # 更改分隔符
for folder in $PATH;do
  echo "$folder:"
  for file in $folder;do
    if [ -x file ];then
      echo "  $file"
    fi
  done
done
```

遍历参数
```shell
#!/usr/bin/env bash
if [ $# -ne 5 ];then
  echo "需要5个参数"
  exit 2
fi
for param in $@;do
  echo $param
done
```

### break,continue

`break`命令立即终止循环,程序继续执行循环块之后的语句,即不再执行剩下的循环。
```
#!/usr/bin/env bash

for number in 1 2 3 4 5 6
do
  echo "number is $number"
  if [ "$number" = "3" ]; then
    break
  fi
done
```
上面例子只会打印3行结果。一旦变量`$number`等于3,就会跳出循环,不再继续执行。

`continue`命令立即终止本轮循环,开始执行下一轮循环。
```
#!/usr/bin/env bash

while read -p "What file do you want to test?" filename
do
  if [ ! -e "$filename" ]; then
    echo "The file does not exist."
    continue
  fi

  echo "You entered a valid file.."
done
```

### select

`select`结构主要用来生成简单的菜单。它的语法与`for...in`循环基本一致。
```
#!/usr/bin/env bash

echo "Which Operating System do you like?"

select os in Ubuntu LinuxMint Windows8 Windows7 WindowsXP
do
  case $os in
    "Ubuntu"|"LinuxMint")
      echo "I also use $os."
    ;;
    "Windows8" | "Windows7" | "WindowsXP")
      echo "Why don't you try Linux?"
    ;;
    *)
      echo "Invalid entry."
      break
    ;;
  esac
done
```

### shift
```shell
$ cat shift.sh
#!/usr/bin/env bash

echo 
count=1
while [ -n $1 ];do
  echo "Parameter #$count = $1"
  count=$[ $count + 1 ]
  shift
done

./shift.sh rich barbara katie jessica
Parameter #1 = rich
Parameter #2 = barbara
Parameter #3 = katie
Parameter #4 = jessica
```