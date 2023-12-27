# terminal配置

keyword: color ssm提示符 shell提示符

可以写入`~/.bashrc`,也可作为SSM的登录配置

```bash
export EDITOR=vim
# 添加用户目录
export PATH=/home/admin/bin:/data/admin:$PATH
export PS1='\[\e[1;38;5;135m\]\u\[\e[0m\]\[\e[1;38;5;226m\]@\[\e[0m\]\[\e[1;38;5;200m\]\h\[\e[0m\] [\[\e[1;36m\]\w\[\e[0m\]]$(if [[ $? = "0" ]]; then echo "\[\e[1;32m\]"; else echo "\[\e[1;31m\]"; fi)\[\e[0m\]\n[\[\e[1;92m\]\D{%Y-%m-%d %H:%M:%S}\[\e[0m\]] > '
export PS2='> '
```

# alias

如果别名特别多,可以创建单独的`~/.alias`文件存放别名,并在`~/.bashrc`中读取
```
if [ -f ~/.alias ]; then
  source ~/.alias
fi
```

alias相关操作
```bash
$ alias hw='echo "hello world"' # 新增别名 只在当前终端有效
$ alias      # 查看现有别名
$ unalias ll # 取消单个别名
$ unalias -a # 取消所有别名 如果别名是写在文件中,即使使用命令取消了别名,用户重新登陆别名还是存在的.

```

常见alias配置
```bash
alias l="ls -lah --color=always"
alias ll="ls -lah --color=always"
alias s.="source ~/.bashrc"
alias v.="vim ~/.alias"
alias checkip="curl checkip.amazonaws.com"
```