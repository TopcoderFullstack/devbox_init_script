#!/bin/bash

echo "开始初始化环境..."

echo -e "\n\033[33m1. 运行系统设置...\033[0m"
bash setup.sh

echo -e "\n\033[33m2. 配置 GitHub...\033[0m"
bash gh-install.sh

echo -e "\n\033[33m3. 安装命令...\033[0m"
bash install-command.sh

echo -e "\n\033[32m所有配置已完成！\033[0m"