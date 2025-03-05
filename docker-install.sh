#!/bin/bash
set -e

# 检查是否已安装docker
if command -v docker &> /dev/null; then
    echo "Docker is already installed. Version: $(docker --version)"
    exit 0
fi

# 卸载旧版本
sudo apt-get remove docker docker-engine docker.io containerd runc || true

# 设置仓库
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common

# 添加官方GPG密钥
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 设置稳定版仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装Docker引擎
sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# 配置用户组
sudo usermod -aG docker $USER
# newgrp docker

# 启动服务
sudo systemctl enable docker.service
sudo systemctl start docker.service

# 添加延迟确保服务就绪
sleep 3

echo "Docker installed successfully. Version: $(docker --version)"