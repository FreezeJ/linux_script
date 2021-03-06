# coding:utf8
# 配置zsh环境脚本


cd ~  # 进入用户家目录

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

PLUGINS="plugins=(git autojump zsh-syntax-highlighting zsh-completions zsh-autosuggestions)"
grep "$PLUGINS" ~/.zshrc
if [ $? -ne 0 ]; then  # 安装和配置autojump
    echo 安装autojump
    cd ~/.oh-my-zsh/
    git clone https://github.com/FreezeJ/autojump
    cd ~/.oh-my-zsh/autojump
    python install.py
    AUTOJUMP="[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
"
    AUTOJUMP_PATTERN=\"1"a\\$AUTOJUMP"\"
    AUTOLOAD="autoload -U compinit && compinit -u"
    AUTOLOAD_PATTERN=\"1"a\\$AUTOLOAD"\"
    cat ~/.zshrc | grep autoload | grep compinit || bash -c "sed -i $AUTOLOAD_PATTERN ~/.zshrc"
    cat ~/.zshrc | grep source | grep autojump.sh || bash -c "sed -i $AUTOJUMP_PATTERN ~/.zshrc"

    cd ~/.oh-my-zsh/
    git clone https://github.com/FreezeJ/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/^plugins=/\# plugins=/g' ~/.zshrc  # 注释原有的插件列表
    PLUGINS_PATTERN=\"1"a\\$PLUGINS"\"
    bash -c "sed -i $PLUGINS_PATTERN ~/.zshrc"
fi

grep "ZSH_DISABLE_COMPFIX = true" ~/.zshrc
if [ $? -ne 0 ]; then
    sed -i '1a\ZSH_DISABLE_COMPFIX=true' ~/.zshrc
fi


# 编辑
zsh -c "source ~/.zshrc"  # 刷新配置
echo "----------安装完成----------"
echo 请运行 "chsh -s /bin/zsh" 切换默认shell为zsh,命令行输入zsh回车马上使用zsh。  # 切换默认shell>为zsh，需要用户输入密码
