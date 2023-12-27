### vim
`~/.vimrc` 配置文件

显示号: :set nu

保存退出: `:wq` `ZZ`
取消未保存的修改: `:e!`
左: h
下: j
上: k
右: l
行首: 0
行尾: $
替换: r R
下一个单词: w W
上一个单词: b B
移动到首行: gg 1G
移动到尾行: G
移动到行首: 0 ^
移动到行尾: $
更改整个单词: cw
更改整行: cc
更改到整首: c0
更改到整尾: c$
删除整行: dd



```
vim -O abc 123 # 同时打开两个文件 ctrl + w 之后加左右箭头
光标移动:hjkl
查找:/ ?
行首行尾:^ $
gg G
字符替换:r R
字符删除:x 10x
行删除:dd dw d$ d^ dG
:1,10d
yw y$ y^ 
p P
w filename
n,ms/old/new/g:替换行号n和m之间所有old
%s/old/new/g:替换整个文件中的所有old
:!   :r !date   :r /root/1.txt
:map ^P I#<ESC>  ^P = ctrl + v + ctrl + p  # 快捷键
:ab mymail 1234@qq.com  # 字符替换:
:set nu/nonu   # 行号
:set hlsearch/nohlsearch  # 搜索高亮
:set syntax on/off  
:set list/nolist
```