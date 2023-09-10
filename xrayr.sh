#!/bin/sh

# 发送欢迎消息
echo "XrayR一键安装脚本"
echo "仅支持Alpine 3.5+ amd64架构"
echo "安装目录位于 /etc/XrayR"
echo "进程保活采用OpenRC方式"
echo "请选择:"
echo "1:安装XrayR"
echo "2:卸载XrayR"
echo "3:启动XrayR"
echo "4:停止XrayR"
echo "5:重启XrayR"
echo "6:退出脚本"

# 检查XrayR是否安装
if [ -d "/etc/XrayR" ]; then
    xrayr_status="已安装"
else
    xrayr_status="未安装"
fi

echo "XrayR是否安装: $xrayr_status"

# 检查XrayR运行状态
xrayr_service_status=$(rc-service XrayR status 2>&1)

if echo "$xrayr_service_status" | grep -q "does not exist"; then
    echo "XrayR运行状态: 未运行"
else
    echo "XrayR运行状态:"
    echo "$xrayr_service_status"
fi

# 检查脚本是否以root用户运行
if [ "$(id -u)" -ne 0 ]; then
    echo "必须使用root用户运行此脚本！"
    exit 1
fi

# 定义安装XrayR的函数
install_xrayr() {
    # 检查一下必要的软件包是否安装
    if ! command -v sudo >/dev/null 2>&1; then
        apk add sudo
    fi
    if ! command -v wget >/dev/null 2>&1; then
        apk add wget
    fi
    if ! command -v curl >/dev/null 2>&1; then
        apk add curl
    fi
    if ! command -v unzip >/dev/null 2>&1; then
        apk add unzip
    fi
    
    # 检查 /etc/XrayR 目录是否存在
    if [ -d "/etc/XrayR" ]; then
        echo "已存在文件夹，可能已经安装过了XrayR"
        exit 1
    fi

    # 检查系统是否为Alpine
    if ! grep -qi "Alpine" /etc/os-release; then
        echo "请使用Alpine系统运行此脚本"
        exit 1
    fi
    
    # 获取Alpine系统版本
    alpine_version=$(awk -F= '/^VERSION_ID/ {gsub(/"/, "", $2); print $2}' /etc/os-release)

    # 检查系统版本是否低于3.5
    if [ "$alpine_version" \< "3.5" ]; then
        echo "你的系统版本过低，请升级至Alpine 3.5或更高版本"
        exit 1
    fi

    # 检查系统架构是否为amd64
    if [ "$(uname -m)" != "x86_64" ]; then
        echo "该脚本暂只支持amd64架构"
        exit 1
    fi

    # 切换到 /etc 目录
    cd /etc

    # 开始下载XrayR，先检测版本，再创建目录，再进行安装
    last_version=$(curl -Ls "https://api.github.com/repos/XrayR-project/XrayR/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ -z "$last_version" ]; then
        echo "检测 XrayR 版本失败，请稍后再试"
        exit 1
    fi

    mkdir XrayR
    cd XrayR
    wget -N --no-check-certificate "https://github.com/XrayR-project/XrayR/releases/download/${last_version}/XrayR-linux-64.zip"
    unzip XrayR-linux-64.zip
    chmod 777 XrayR
    echo "正在写入rc-service……"
    cd /etc/init.d
    wget https://raw.githubusercontent.com/mingge9527/XrayR-For-Alpine/openrc/XrayR
    chmod 777 XrayR
    rc-update add XrayR default
    
    if [ $? -eq 0 ]; then
        echo "XrayR已安装完成，请先配置好配置文件后再启动"
    else
        echo "XrayR安装失败"
    fi

    exit 0
}

# 根据用户选择执行相应操作
read -p "请输入选项: " option

case "$option" in
    "1")
        install_xrayr
        ;;
    "2")
        if [ ! -d "/etc/XrayR" ]; then
            echo "你还未安装XrayR"
            exit 1
        fi

        # 确认卸载
        read -p "确认要卸载XrayR吗？[y/n]: " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            cd /etc/init.d
            rc-service XrayR stop
            rc-update del XrayR default
            rm XrayR
            rm -rf /etc/XrayR

            echo "XrayR卸载成功"
        else
            echo "取消卸载"
        fi
        exit 0
        ;;
    "3")
        if [ ! -d "/etc/XrayR" ]; then
            echo "你似乎并未安装XrayR"
            exit 1
        fi

        if rc-service XrayR status | grep -q "* status: started"; then
            echo "你已经启动过了XrayR"
            exit 1
        fi

        rc-service XrayR start

        echo "XrayR启动成功"
        exit 0
        ;;
    "4")
        if [ ! -d "/etc/XrayR" ]; then
            echo "你似乎并未安装XrayR"
            exit 1
        fi
        
        rc-service XrayR stop

        echo "XrayR停止成功"
        exit 0
        ;;
    "5")
        if [ ! -d "/etc/XrayR" ]; then
            echo "你似乎并未安装XrayR"
            exit 1
        fi
    
        rc-service XrayR restart
        
        echo "XrayR重启成功"
        exit 0
        ;;
    "6")
        echo "已退出脚本"
        exit 0
        ;;
    *)
        if [ -n "$option" ]; then
            echo "无效的选择"
        fi
        exit 1
        ;;
esac
