- [常规](#常规)
  - [快捷键](#快捷键)
- [配置](#配置)
  - [脚本执行位置](#脚本执行位置)
  - [alias](#alias)
  - [history](#history)
  - [logout](#logout)

## 常规

### 快捷键
```
Tab：自动补全
Ctrl + r:实现快速检索使用过的历史命令.
Ctrl + l:清除屏幕
Ctrl + a:跳到本行的行首
Ctrl + e:光标回到命令行尾。
Ctrl + u:删除当前光标前面的文字(还有剪切功能)
Ctrl + k:删除当前光标后面的文字(还有剪切功能)
Ctrl + w:删除当前光标前一个单词
Ctrl + y:粘贴
Ctrl + c:终止当前命令
Ctrl + d:删除当前字符，没有字符时会退出shell
ESC + f:移动光标到后一个单词
ESC + b:移动光标到前一个单词
```

## 配置

### 脚本执行位置

当写了一个经常使用的脚本时，可以在主目录新建一个`~/bin`子目录，专门存放可执行脚本，然后把`~/bin`加入`$PATH`。
```
export PATH=$PATH:~/bin
```

上面命令改变环境变量`$PATH`，将`~/bin`添加到`$PATH`的末尾。可以将这一行加到`~/.bashrc`文件里面，然后重新加载一次`.bashrc`，这个配置就可以生效了。

```
$ source ~/.bashrc
```

以后不管在什么目录，直接输入脚本文件名，脚本就会执行。

### alias

新建或打开 ~/.bashrc
```shell
vim ~/.bashrc
```

输入以下内容，这是git常用的几个命令。
```shell
alias pull="git pull"
alias commit="git commit"
alias push="git push"
alias branch="git branch"
alias check="git checkout"
alias st="git status"
```

让别名立即生效
```shell
source ~/.bashrc
```

让别名永久生效，新建或打开 ~/.bash_profile
```shell
vim ~/.bash_profile
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
```

如果别名特别多，我们可以创建单独的`~/.alias`文件存放别名,并在`~/.bashrc`中读取
```
if [ -f ~/.alias ]; then
  source ~/.alias
fi
```

### history

1. history的历史命令保存在`~/.bash_history` 文件中,仅仅对当前用户有效，应设置全局环境变量/etc/profile
```
echo 'export HISTTIMEFORMAT="%Y-%m-%d:%H-%M-%S `whoami`:  "' >> /etc/profile && source /etc/profile
```


2. `~/.bashrc`文件可添加的history相关的说明        
```bash
HISTFILESIZE=2000      # 设置保存历史命令的文件大小        
HISTSIZE=2000          # 保存历史命令条数        
HISTTIMEFORMAT="%Y-%m-%d:%H-%M-%S `whoami`:  "    # 记录每条历史命令的执行时间和执行者        
export HISTTIMEFORMAT    

# 其中： date +%Y-%m-%d ==2017-06-09
# %Y:4位数的年份；        
# %m:2位数的月份数；        
# %d:2位数的一个月中的日期数；        
# %H：2位数的小时数（24小时制）；        
# %M：2位数的分钟数；        
# %S：2位数的秒数 
```

### logout

当用户登出会话时，会执行文件`$HOME/.bash_logout`
```shell
cat ~/.bash_logout
# 远程登出之后清屏
Clear 
```

