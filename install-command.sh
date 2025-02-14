#!/bin/bash

# 创建用户级的 bin 目录
mkdir -p ~/.local/bin

# 检查并替换现有命令
if [ -f ~/.local/bin/create-repo ] || [ -f ~/.local/bin/delete-repo ] || [ -f ~/.local/bin/open-repo ] || [ -f ~/.local/bin/push-repo ]; then
    echo -e "\033[33m检测到已存在的命令，正在更新...\033[0m"
    rm -f ~/.local/bin/create-repo ~/.local/bin/delete-repo ~/.local/bin/open-repo ~/.local/bin/push-repo
fi

# 复制脚本到 bin 目录
cp create-repo.sh ~/.local/bin/create-repo
cp delete-repo.sh ~/.local/bin/delete-repo
cp open-repo.sh ~/.local/bin/open-repo
cp push-repo.sh ~/.local/bin/push-repo

# 添加执行权限
chmod +x ~/.local/bin/create-repo
chmod +x ~/.local/bin/delete-repo
chmod +x ~/.local/bin/open-repo
chmod +x ~/.local/bin/push-repo

# 检查 PATH 中是否已包含用户 bin 目录
if ! echo $PATH | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi

echo -e "\033[32m安装完成！现在可以直接使用 create-repo、delete-repo、open-repo 和 push-repo 命令了\033[0m"
echo -e "\033[32m请打开新的终端来验证工具。\033[0m"