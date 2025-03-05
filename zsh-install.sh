#!/bin/bash

# 安装zsh核心
sudo apt-get update && sudo apt-get install -y zsh

# 设置zsh为默认shell（继承bash参数）
if [ -f "/bin/zsh" ]; then
    sudo chsh -s $(which zsh) $USER
    # 将bash配置继承到zsh
    [ -f ~/.bashrc ] && ln -sf ~/.bashrc ~/.zshrc || touch ~/.zshrc
fi

# 安装oh-my-zsh及其依赖
sudo apt-get install -y curl git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 应用配置
if [ -d "$HOME/.oh-my-zsh" ]; then
    # 保留原始zsh配置
    [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    # 加载bash环境变量
    echo -e "\n# Inherit bash environment\nsource ~/.bashrc" >> ~/.zshrc
fi

echo "安装完成，请重新登录或执行 zsh 激活新配置"