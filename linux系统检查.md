
# 系统信息

```bash
lscpu
cat /proc/cpuinfo | grep processor | wc -l #显示CPU核数
arch      #显示机器的处理器架构(1)
uname -a  #显示机器的处理器架构(2)
dmidecode -q          #显示硬件系统部件 - (SMBIOS / DMI)
hdparm -i /dev/hda    #罗列一个磁盘的架构特性
hdparm -tT /dev/sda   #在磁盘上执行测试性读取操作
cat /proc/cpuinfo     #显示CPU info的信息
cat /proc/interrupts  #显示中断
cat /proc/meminfo     #校验内存使用
cat /proc/swaps       #显示哪些swap被使用
cat /proc/version     #显示内核的版本
cat /proc/net/dev     #显示网络适配器及统计
cat /proc/mounts      #显示已加载的文件系统
```

查看内存: `free -m`
列出块设备信息: `lsblk`
查看每个文件夹的占用情况并排序: `du -sh * |sort -rh`
查看系统剩余空间和文件系统: `df -Th`
