# XrayR-For-Alpine
这是一个适用于amd64架构的Alpine系统的XrayR一键脚本

安装目录位于 /etc/XrayR

控制程序启动关闭采用系统级的OpenRC

运行脚本需要以root用户运行

# NEW
快速配置config.yml已经实现，若有问题可以issues进行反馈

# 安装脚本
```shell script
apk add wget ; wget -O /usr/bin/xrayr https://raw.githubusercontent.com/mingge9527/XrayR-For-Alpine/openrc/xrayr.sh ; chmod 777 /usr/bin/xrayr ; xrayr
```
下次运行即可直接输入
```shell script
xrayr
```
