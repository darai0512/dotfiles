if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
eval `ssh-agent`
