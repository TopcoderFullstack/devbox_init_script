#!/bin/bash

# 获取 GitHub 用户名
gh_username=$(gh api user | grep login | cut -d'"' -f4)

# 获取仓库列表
echo "正在获取仓库列表..."
repos=($(gh repo list --json nameWithOwner --jq '.[].nameWithOwner' | sort))

if [ ${#repos[@]} -eq 0 ]; then
    echo "没有找到任何仓库"
    exit 1
fi

# 显示仓库选择界面
selected=0
while true; do
    # 清屏
    clear
    echo -e "\033[32m使用上下箭头选择仓库，回车确认：\033[0m"
    echo ""

    # 显示选项
    for i in "${!repos[@]}"; do
        if [ $i -eq $selected ]; then
            echo -e "\033[7m> ${repos[$i]}\033[0m"
        else
            echo "  ${repos[$i]}"
        fi
    done

    # 读取按键
    read -rsn1 key
    case "$key" in
        A) # 上箭头
            [ $selected -gt 0 ] && selected=$((selected-1))
            ;;
        B) # 下箭头
            [ $selected -lt $((${#repos[@]}-1)) ] && selected=$((selected+1))
            ;;
        "") # 回车
            selected_repo="${repos[$selected]}"
            break
            ;;
    esac
done

# 提取仓库名称
repo_name=$(echo "$selected_repo" | cut -d'/' -f2)

# 检查仓库是否已经存在
if [ -d "$repo_name" ]; then
    echo "仓库目录已存在，直接进入目录"
    cd "$repo_name"
else
    # 克隆仓库
    echo "正在克隆仓库: $selected_repo"
    git clone "git@github.com:$selected_repo.git"
    if [ $? -eq 0 ]; then
        cd "$repo_name"
    else
        echo "仓库克隆失败"
        exit 1
    fi
fi

echo -e "\n\033[32m成功进入仓库！\033[0m"
echo -e "仓库地址: https://github.com/$selected_repo"
echo -e "本地路径: $(pwd)"

# 检查是否安装了 trae 或 vscode
if command -v trae >/dev/null 2>&1; then
    trae $(pwd)
elif command -v code >/dev/null 2>&1; then
    code $(pwd)
fi

sleep 2
# 在浏览器中打开仓库
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "https://github.com/$selected_repo" &
elif command -v open >/dev/null 2>&1; then
    open "https://github.com/$selected_repo" &
fi

