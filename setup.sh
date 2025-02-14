#!/bin/bash

# 安装 Volta
curl https://get.volta.sh | bash

# 直接设置 Volta 的环境变量
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# 重新加载 .bashrc 以使 Volta 生效
source ~/.bashrc

# 使用 Volta 安装 Node.js（这里安装 LTS 版本）
volta install node@lts

# 使用 Volta 安装 pnpm
volta install pnpm@latest

# 运行 pnpm setup
pnpm setup

# 再次重新加载 .bashrc 以使 pnpm 的配置生效
source ~/.bashrc

echo "安装完成！"