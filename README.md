# XrayR-For-Alpine
适用于amd64架构的Alpine系统的XrayR一键脚本

安装目录位于 /etc/XrayR

运行脚本需要以root用户运行

若有问题欢迎提交issues反馈

# 安装脚本

基于screen保活方案的一键脚本

```shell script
apk add wget ; wget -O /usr/bin/xrayr https://raw.githubusercontent.com/mingge9527/XrayR-For-Alpine/main/xrayr.sh ; chmod 777 /usr/bin/xrayr ; xrayr
```
基于openrc保活方案的一键脚本

```shell script
apk add wget ; wget -O /usr/bin/xrayr https://raw.githubusercontent.com/mingge9527/XrayR-For-Alpine/openrc/xrayr.sh ; chmod 777 /usr/bin/xrayr ; xrayr
```
下次运行即可直接输入
```shell script
xrayr
```

本项目基于
https://github.com/XrayR-project/XrayR
二次开发
