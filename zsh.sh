# coding:utf8
# 配置zsh环境脚本

if [[ ! -f /bin/zsh ]]; then  # 如果不存在zsh则安装zsh
	echo "请输入sudo密码，安装zsh和git："
	sudo yum install -y zsh git
fi

if [[ ! -d ~/.oh-my-zsh/ ]]; then  # 如果不存在zsh则安装zsh
    echo 安装oh-my-zsh
    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh  # 安装oh-my-zsh
fi

if [[ ! -f ~/.oh-my-zsh/themes/zeta.zsh-theme ]]; then  # 如果不存在zeta主题，则安装
    echo 安装zeta主题
    cd ~/.oh-my-zsh/themes
    wget https://raw.githubusercontent.com/FreezeJ/zeta-zsh-theme/master/zeta.zsh-theme -O zeta.zsh-theme
    grep ZSH_THEME="zeta" ~/.zshrc
    if [[ $? -ne 0 ]]; then
        sed -i 's/^ZSH_THEME=/\# ZSH_THEME=/g' ~/.zshrc  # 注释原来的主题配置
        sed -i '/^# ZSH_THEME=/a\ZSH_THEME="zeta"' ~/.zshrc  # 追加一行
    fi
fi


if [[ ! -d ~/.oh-my-zsh/autojump ]]; then  # 安装和配置autojump
    echo 安装autojump
    cd ~/.oh-my-zsh/
    git clone https://github.com/FreezeJ/autojump
    cd ~/.oh-my-zsh/autojump
    python install.py

    cd ~/.oh-my-zsh/
    git clone https://github.com/FreezeJ/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    sed -i 's/^plugins=/\# plugins=/g' ~/.zshrc
    sed -i '/^# plugins=/a\plugins=(git autojump zsh-syntax-highlighting)' ~/.zshrc  # 追加一行
fi



# 编辑
zsh  # 先切换到zsh，否则source会报错
source ~/.zshrc  # 刷新配置
echo "输入密码改变默认shell为zsh"
chsh -s /bin/zsh   # 切换默认shell为zsh，需要用户输入密码


