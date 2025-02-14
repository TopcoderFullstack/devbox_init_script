#!/bin/bash

# 获取 GitHub 用户名
gh_username=$(gh api user | grep login | cut -d'"' -f4)

# 列出用户的所有仓库
echo -e "\033[33m您的仓库列表：\033[0m"
gh repo list --limit 100 --json name --jq '.[].name'

echo -e "\n\033[32m请输入要删除的仓库名称：\033[0m"
read repo_name

# 检查仓库是否存在
if ! gh repo view "$gh_username/$repo_name" &>/dev/null; then
    echo -e "\033[31m错误：仓库 '$repo_name' 不存在\033[0m"
    exit 1
fi

# 二次确认
echo -e "\n\033[31m警告：此操作将永久删除仓库 '$repo_name'，包括所有代码、提交历史和分支\033[0m"
read -p "确认删除？(yes/N): " confirm

if [[ $confirm == "yes" ]]; then
    # 检查本地是否存在同名目录
    if [ -d "$repo_name" ]; then
        echo "删除本地仓库..."
        rm -rf "$repo_name"
    fi
    
    # 删除远程仓库
    echo "删除远程仓库..."
    gh repo delete "$gh_username/$repo_name" --yes
    
    echo -e "\033[32m仓库删除完成\033[0m"
else
    echo "操作已取消"
fi