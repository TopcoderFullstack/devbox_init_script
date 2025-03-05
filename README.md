## How to Use

### 基础初始化
```bash
# 仅初始化基础环境
bash init.sh

# 安装Docker（短选项）
bash init.sh -id

# 安装ZSH环境（短选项）
bash init.sh -iz

# 同时安装Docker和ZSH
bash init.sh --install-docker --install-zsh

# 使用混合参数安装
bash init.sh -id -iz