sudo apt update
sudo apt install -y gh git xdg-utils xclip
# 创建一个函数来处理登录过程
handle_login() {
    yes | gh auth login --hostname github.com --git-protocol https --web --scopes repo,admin:public_key,user,user:email,delete_repo 2>&1 | while read -r line; do
        echo "$line"
        if [[ $line =~ "code: " ]]; then
            # 提取并复制验证码
            code=$(echo "$line" | grep -o '[A-Z0-9]\{4\}-[A-Z0-9]\{4\}')
            # echo "$code" | xclip -selection clipboard
            echo -e "\n\033[32m验证码: $code\033[0m\n"
        fi
        if [[ $line =~ "https://github.com/login/device" ]]; then
            url=$(echo "$line" | grep -o 'https://github.com/login/device')
            xdg-open "$url" &
        fi
    done
}

handle_login
# 获取 GitHub 用户信息
echo "获取 GitHub 账户信息..."
gh_username=$(gh api user | grep login | cut -d'"' -f4)
gh_email=$(gh api user/emails | grep email | head -n 1 | cut -d'"' -f4)

echo "您的 GitHub 用户名: $gh_username"
echo "您的 GitHub 邮箱: $gh_email"

# 设置 Git 全局配置
git config --global user.name "$gh_username"
git config --global user.email "$gh_email"

# 生成 SSH 密钥对
if [ -f ~/.ssh/github_ed25519 ]; then
    echo "检测到已存在的 SSH 密钥，正在替换..."
    rm -f ~/.ssh/github_ed25519 ~/.ssh/github_ed25519.pub
fi
ssh-keygen -o -a 150 -t ed25519 -C "$(git config --get user.email)" -f ~/.ssh/github_ed25519 -N ""

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_ed25519

touch ~/.ssh/config
echo "Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_ed25519" >> ~/.ssh/config

# 显示生成的 SSH 公钥
echo "以下是您的 SSH 公钥内容："
cat ~/.ssh/github_ed25519.pub

# 自动添加 SSH 密钥到 GitHub
echo "正在将 SSH 密钥添加到 GitHub..."
gh ssh-key add ~/.ssh/github_ed25519.pub --title "$(hostname)-$(date +%Y%m%d)"

# echo -e "\n请将上述公钥添加到 GitHub 的 SSH Keys 中 Settings -> SSH and GPG keys -> New SSH key "

random_name="topcoderfullstack-$(shuf -i 10000000-99999999 -n 1)"

# 创建远程仓库并克隆到本地
echo "正在创建仓库: $random_name"
gh repo create "$random_name" --private

# 等待几秒确保仓库创建完成
sleep 3

# 克隆仓库
git clone "git@github.com:$gh_username/$random_name.git"
if [ $? -eq 0 ]; then
    cd "$random_name"
    echo "仓库创建成功并已克隆到本地: $(pwd)"
    
    # 创建并切换到 main 分支
    git checkout -b main
    
    # 创建并编辑 README.md
    echo "test - $(date '+%Y-%m-%d %H:%M:%S')" > README.md
    
    # 提交并推送更改
    git add README.md
    git commit -m "test"
    git push -u origin main

    # 验证远程仓库状态
    echo "正在验证远程仓库..."
    if gh repo view "$gh_username/$random_name" --json defaultBranchRef | grep -q "main"; then
        echo "验证成功：仓库创建并推送成功"

        echo -e "\n\033[33m请在浏览器中确认远程仓库 https://github.com/$gh_username/$random_name 是否已更新\033[0m"
        read -p "确认远程仓库已更新？(y/n): " confirm
        
        # 退出目录并删除本地仓库
        cd ..
        rm -rf "$random_name"
        
        # 删除远程仓库
        echo "正在删除远程仓库..."
        gh repo delete "$gh_username/$random_name" --yes
        echo "仓库清理完成"
    else
        echo "验证失败：仓库未正确创建或推送"
        exit 1
    fi
else
    echo "仓库创建失败"
    exit 1
fi