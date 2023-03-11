常用选项：
```
-n∶使用安静(silent)模式。只有经过sed特殊处理的那一行(或者动作)才会被列出来。
-e∶直接在指令列模式上进行 sed 的动作编辑
-f∶直接将 sed 的动作写在一个档案内， -f filename 则可以执行filename 内的sed 动作
-r∶sed 的动作支援的是延伸型正规表示法的语法。(预设是基础正规表示法语法)
-i∶直接修改读取的档案内容，而不是由萤幕输出。
```

常用命令
```
a   ∶新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)
c   ∶取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
d   ∶删除
i   ∶插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
p   ∶列印，亦即将某个选择的资料印出。通常 p 会与参数 sed -n 一起运作
s   ∶取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g
=   ：打印行号
```

简单示例
```shell
$ cat data1.txt 
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.

$ sed 's/dog/cat/' data1.txt
The quick brown fox jumps over the lazy cat.
The quick brown fox jumps over the lazy cat.

# 执行多个命令用分号隔开
$ sed -e 's/brown/green/;s/dog/cat/;s/fox/elephant/' data1.txt
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat.
```

sed文件，如果有大量要处理的sed命令，那么将它们放进一个单独的文件中通常会更方便一些。 可以在sed命令中用-f选项来指定文件。

```shell
$ cat script1.sed 
s/brown/green/
s/fox/elephant/
s/dog/cat/

$ sed -f script1.sed data1.txt 
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat.
```

每行中第二次出现的匹配模式
```shell
sed 's/test/trial/2' data4.txt

# 默认只作用于第一次出现的位置
sed 's/test/trial/' data4.txt

# 作用于所有出现的位置
sed 's/test/trial/g' data4.txt
```

只显示更改的行
```shell
sed -n 's/test/trial/p' data5.txt
```

将更改写入其他文件
```shell
sed 's/test/trial/w test.txt' data5.txt
```

### 指定位置替换
```shell
sed 's/dog/cat/' data1.txt # 只作用于每行的第一次
sed '2s/dog/cat/' data1.txt # 只作用于第二行
sed '2,3s/dog/cat/' data1.txt # 作用于2-3行
sed '2,$s/dog/cat/' data1.txt # 第二行至末行
```

### 文本模式过滤

文本模式过滤模式在前方写入pattern，会匹配具有这个pattern的行
示例
```shell
# 在匹配到Samantha的行中，将bash换为zsh
sed '/Samantha/s/bash/csh/' /etc/passwd
```

在单行中执行多条命令
```shell
sed '2{s/Two/2/;s/test/real/}' data2.txt
sed '3,${s/Two/2/;s/test/real/}' data2.txt
```

### 删除行
```shell
# 删除单行
sed '3d' data6.txt
# 删除区间
sed '3,$d' data2.txt
# 模式匹配删除
sed '/number 1/d' data6.txt
```

### 插入和追加
```shell
sed '1i\Test Line 1' data2.txt 
sed '$a\Test Last Line ' data2.txt 

# 通过读取文件的形式追加
$ cat data12.txt
This is an added line.
This is the second added line.
$ sed '3r data12.txt' data6.txt 
This is line number 1.
This is line number 2.
This is line number 3.
This is an added line.
This is the second added line. 
This is line number 4.
```

#### 修改整行
```shell
# 以模式匹配方式整行替换
sed '/One/c\new line' data2.txt 

# 以行号方式
sed '1c\new line' data2.txt 

### 区间替换会有问题
```

#### 映射转换
```shell
$ cat data3.txt 
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
$ sed 'y/123/456/' data3.txt
This is line number 4.
This is line number 5.
This is line number 6.
This is line number 4.
```

#### 打印输出
```shell
# 命令行上用-n选项，可以禁止输出其他行，只打印包含匹配文本模式的行
$ sed -n '2,3p' data3.txt
This is line number 2.
This is line number 3.
```

sed编辑器不会修改原始文件。你删除的行只是从sed编辑器的输出中消失了。原始文件仍然包含那些“删掉的”行。

#### 多行操作
```
$ cat data3.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All System Administrators should attend.
Thank you for your attendance.

# 替换命令在System和Administrator之间用了通配符模式(.)来匹配空格和换行符
# 但是这样会导致换行符消失
$ sed 'N ; s/System.Administrator/Desktop User/' data3.txt
On Tuesday, the Linux Desktop User's group meeting will be held. All Desktop Users should attend.
Thank you for your attendance.


$ cat data4.txt
On Tuesday, the Linux System
Administrator's group meeting will be held. 
All System Administrators should attend. To System
Administrator!
$ sed 's/System Administrator/Desktop User/;N;s/System\nAdministrator/Desktop\nUser/' data4.txt
On Tuesday,the Linux Desktop
User's group meeting will be held. 
All Desktop Users should attend. To Desktop
User!
```

- h: 将模式空间复制到保持空间
- H: 将模式空间附加到保持空间
- g: 将保持空间复制到模式空间
- G: 将保持空间附加到模式空间
- x: 交换模式空间和保持空间的内容

```shell
# 将文件进行反转，效果类似tac
sed -n '{1!G ; h ; $p }' data2.txt
```

#### 模式替换

```shell
# &符号可以用来代表替换命令中的匹配的模式
echo "The cat slleps in his hat" | sed 's/.at/"&"/g'
The "cat" slleps in his "hat"

# 使用（）将其标示为一个子模式。然后它在替代模 式中使用\1来提取第一个匹配的子模式
echo "That furry cat is pretty" | sed 's/furry \(.at\)/\1/' 
That cat is pretty

# 综合，这里用到了测试t进行跳转
echo "1234567" | sed ': start ; s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;t start'
1,234,567
```

### sed实用命令
#### 加倍行间距
```shells
# 除最后一行之外将保持空间中的空白加入到模式空间
sed '$!G' data4

# 删除已有的空白行再添加空白行
sed '/^$/d ; $!G' data6.txt
```

#### 给文件添加行号
```shell
sed '=' data4 | sed 'N;s/\n/ /'
```

#### 打印尾行
```shell
# tail -n 1
sed -n '$p' data2.txt
```

#### 删除连续的空白行
无论文件的数据行之间出现了多少空白行，在输出中只会在行间保留一个空白行。

```shell
# 区间是/./到/^$/。区间的开始地址会匹配任何含有至少一个字符的行。区间的结束地址会 匹配一个空行。在这个区间内的行不会被删除。
sed '/./,/^$/!d' data8.txt
```

#### 删除开头的空白行
```shell
# 区间从含有字符的行开始，一直到数据流结 束
sed '/./,$!d' data9.txt
```



#### 删除行首空格
```shell
sed 's/^[ ]*//g' filename
sed 's/^ *//g' filename
sed 's/^[[:space:]]*//g' filename
```

#### 删除HTML标签
```shell
# 排除大于号，否则会进行贪婪匹配，会删除类似<b>first</b>这样的加粗文本
sed 's/<[^>]*>//g ; /^$/d' data11.txt
```

### 问题

**sed: -i may not be used with stdin**

MAC系统上sed使用时需要 
```shell
sed -i '' 's/a/b/' filename
```