#!/bin/bash

echo "开始初始化环境..."

echo -e "\n\033[33m1. 运行系统设置...\033[0m"
bash setup.sh

echo -e "\n\033[33m2. 配置 GitHub...\033[0m"
bash gh-install.sh

echo -e "\n\033[33m3. 安装命令...\033[0m"
bash install-command.sh

# 添加Docker安装参数解析
INSTALL_DOCKER=false
case "$1" in
    "--install-docker"|"-id")
        INSTALL_DOCKER=true
        ;;
esac

# 添加Docker安装逻辑（在包管理之后）
if [ "$INSTALL_DOCKER" = true ]; then
    bash docekr-install.sh
fi

echo -e "\n\033[32m所有配置已完成！\033[0m"