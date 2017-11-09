# alias
alias vi="vim"
alias sc='screen'
alias scr='screen -r'
alias scd='screen -d'
alias rm='rm -i'
alias ls='ls -G' # for mac
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

export LSCOLORS=fxfxcxdxbxegedabagacad
export PS1="\[\033[1;32m\][@\H \w]\n(^o^)/~\$\[\033[0m\]"
# export VIMRUNTIME=
# export MAVEN_HOME=/usr/local/apache-maven-3.2.2
export PYENV_ROOT="$HOME/.pyenv"
export PATH=${PYENV_ROOT}/bin:${PATH}:${MAVEN_HOME}/bin:/opt/chefdk/embedded/bin

#eval "$(chef shell-init bash)"
eval "$(pyenv init -)"

# "stty -a"で見れるdef aliases and functionsをいじる
## C-sによる画面の停止を無効にする
stty stop undef

# Encode
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# 補完に.git以下を現れなくする
export FIGNORE=${FIGNORE}:.git

# sshをscreenからするためにSSH_AUTH_SOCKのパスを固定(別ターミナルを開いた場合など手動で変更)
if [ "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/auth_sock" ]; then
    if [ ! -S $HOME/.ssh/auth_sock ]; then
        rm -f $HOME/.ssh/auth_sock
        ln -fs $SSH_AUTH_SOCK $HOME/.ssh/auth_sock
        export SSH_AUTH_SOCK=$HOME/.ssh/auth_sock
    fi
fi

# screenを張っているときはWINDOW番号をシアンで
if [ -n "${WINDOW}" ] ; then
    PS_SCREEN="\[${COLOUR_CYAN}\]#${WINDOW}\[${COLOUR_DEFAULT}\]"
else
    PS_SCREEN=""
fi

# SSHで繋いでいるときは接続元IPをマゼンダで
if [ -n "${SSH_CLIENT}" ] ; then
    PS_SSH="\[${COLOUR_MAGENTA}\]/$(echo ${SSH_CLIENT} | sed 's/ [0-9]\+ [0-9]\+$//g')\[${COLOUR_DEFAULT}\]"
else
    PS_SSH=""
fi

# ヒストリ設定
## ヒストリ番号を明るい青で
PS_HIST="\[${COLOUR_HIGHLIGHT_BLUE}\]\!\[${COLOUR_DEFAULT}\]"
## 覚える数
export HISTSIZE=10000
## 覚えないコマンド
export HISTIGNORE="ls:fg*:bg*:history*:pwd:df:df *:cd"
## 重複削除
export HISTCONTROL=ignoredups
## ヒストリーに時間も覚えさせる
export HISTTIMEFORMAT='%Y-%m-%d %T '
