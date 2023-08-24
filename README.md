# XrayR-For-Alpine
这是一个适用于arm64架构的Alpine系统的XrayR一键脚本

安装目录位于 /etc/XrayR

控制程序启动关闭采用Screen

运行脚本需要以root用户运行

脚本是用ChatGPT写的，自己稍微改了一些

写这个脚本是因为白嫖的小机只有Alpine

# 安装脚本
```shell script
apk add wget ; wget -O /usr/bin/xrayr https://raw.githubusercontent.com/mingge9527/XrayR-For-Alpine/main/xrayr.sh ; chmod 777 /usr/bin/xrayr ; xrayr
```
下次运行即可直接输入
```shell script
xrayr
```
