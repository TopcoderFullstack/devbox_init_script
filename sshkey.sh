# 设置 Git 全局配置
echo "请输入您的 Git 用户名:"
read git_username
echo "请输入您的 Git 邮箱:"
read git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"

# 生成 SSH 密钥对
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

echo -e "\n请将上述公钥添加到 GitHub 的 SSH Keys 中 Settings -> SSH and GPG keys -> New SSH key "