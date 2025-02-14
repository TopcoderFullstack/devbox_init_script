#!/bin/bash

# 获取 GitHub 用户名
gh_username=$(gh api user | grep login | cut -d'"' -f4)

while true; do
    echo -e "\033[32m请输入要创建的仓库名称：\033[0m"
    read repo_name
    
    # 检查仓库是否已存在
    if gh repo view "$gh_username/$repo_name" &>/dev/null; then
        echo -e "\033[31m错误：仓库 '$repo_name' 已存在，请使用其他名称\033[0m"
        continue
    else
        break
    fi
done

# 选择仓库类型
echo -e "\033[32m请选择仓库类型：\033[0m"
options=("Private (私有)" "Public (公开)")
selected=0
while true; do
    # 显示选项
    for i in "${!options[@]}"; do
        if [ $i -eq $selected ]; then
            echo -e "\033[7m> ${options[$i]}\033[0m"
        else
            echo "  ${options[$i]}"
        fi
    done

    # 读取按键
    read -rsn1 key
    case "$key" in
        A) # 上箭头
            [ $selected -gt 0 ] && selected=$((selected-1))
            ;;
        B) # 下箭头
            [ $selected -lt $((${#options[@]}-1)) ] && selected=$((selected+1))
            ;;
        "") # 回车
            break
            ;;
    esac
    # 清除选项显示
    tput cuu ${#options[@]}
done

# 根据选择设置仓库类型
visibility=$([ $selected -eq 0 ] && echo "--private" || echo "--public")

# 创建远程仓库
echo "正在创建仓库: $repo_name"
gh repo create "$repo_name" $visibility

# 等待仓库创建完成
sleep 2

# 克隆仓库
git clone "git@github.com:$gh_username/$repo_name.git"
if [ $? -eq 0 ]; then
    cd "$repo_name"
    echo "仓库创建成功并已克隆到本地: $(pwd)"
    
    # 创建并切换到 main 分支
    git checkout -b main
    
    # 创建并编辑 README.md
    echo "# $repo_name" > README.md
    echo "Created at $(date '+%Y-%m-%d %H:%M:%S')" >> README.md
    
    # 提交并推送更改
    git add README.md
    git commit -m "Initial commit"
    git push -u origin main

    echo -e "\n\033[32m仓库创建成功！\033[0m"
    echo -e "仓库地址: https://github.com/$gh_username/$repo_name"
    echo -e "本地路径: $(pwd)"
    # 检查是否安装了 trae 或 vscode
    if command -v trae >/dev/null 2>&1; then
        trae $(pwd)
    elif command -v code >/dev/null 2>&1; then
        code $(pwd)
    fi

    sleep 2
    # 在浏览器中打开仓库页面
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "https://github.com/$gh_username/$repo_name" &>/dev/null &
    elif command -v open >/dev/null 2>&1; then
        open "https://github.com/$gh_username/$repo_name" &>/dev/null &
    fi
else
    echo "仓库创建失败"
    exit 1
fi