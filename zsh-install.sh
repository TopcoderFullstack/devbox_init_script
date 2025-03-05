#!/bin/bash

# 安装zsh核心
sudo apt-get update && sudo apt-get install -y zsh

# 设置zsh为默认shell
if [ -f "/bin/zsh" ]; then
    sudo chsh -s $(which zsh) $USER
    # 创建通用配置文件
    [ -f ~/.bashrc ] && grep -E '^export|^source|^alias' ~/.bashrc > ~/.zsh_common
fi

# 安装oh-my-zsh及其依赖
sudo apt-get install -y curl git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 应用配置
if [ -d "$HOME/.oh-my-zsh" ]; then
    # 保留原始配置
    [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    
    # 添加兼容性配置
    cat << 'EOF' >> ~/.zshrc

# 加载通用配置
[ -f ~/.zsh_common ] && source ~/.zsh_common

# ZSH专用设置
if [ -n "$ZSH_VERSION" ]; then
    setopt nocaseglob
    setopt appendhistory
    # Oh My Zsh插件设置
    plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
fi
EOF
fi

echo "安装完成，请重新登录或执行 zsh 激活新配置"