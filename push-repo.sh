#!/bin/bash

# 检查当前目录是否是 git 仓库
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "\033[31m错误：当前目录不是 git 仓库\033[0m"
    exit 1
fi

# 获取当前 git 用户名
git_user=$(git config user.name)

# 拉取最新代码
echo "正在拉取最新代码..."
git pull

# 检查是否有冲突
if [ $? -ne 0 ]; then
    echo -e "\033[31m错误：拉取代码时发生冲突，请手动解决冲突后重试\033[0m"
    exit 1
fi

# 添加所有更改
git add .

# 获取提交信息
echo -e "\033[32m请输入提交信息（直接回车将使用默认信息）：\033[0m"
read commit_message

# 如果用户没有输入提交信息，使用默认信息
if [ -z "$commit_message" ]; then
    commit_message="Update by $git_user at $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 提交更改
git commit -m "$commit_message"

# 推送到远程仓库
echo "正在推送到远程仓库..."
git push

if [ $? -eq 0 ]; then
    # 获取仓库的远程 URL 并转换为 HTTPS 地址
    remote_url=$(git config --get remote.origin.url)
    https_url=$(echo $remote_url | sed 's/git@github.com:/https:\/\/github.com\//')
    https_url=${https_url%.git}

    echo -e "\n\033[32m代码推送成功！\033[0m"
    echo -e "提交信息：$commit_message"
    echo -e "仓库地址：$https_url"

    # 尝试在浏览器中打开仓库
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$https_url" &
    elif command -v open >/dev/null 2>&1; then
        open "$https_url" &
    fi
else
    echo -e "\033[31m推送失败，请检查错误信息\033[0m"
    exit 1
fi