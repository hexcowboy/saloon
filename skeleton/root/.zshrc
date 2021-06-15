# Import aliases
if [ -e $HOME/.aliases ]; then
    source $HOME/.aliases
fi

# Set prompt
export PROMPT='%F{blue}%1~%f %# '

# Enable fuzzyfind completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add rust binaries to the path
export PATH="$PATH:/root/.cargo/bin"

# Add go binaries to the path
export GOPATH="/opt/go"
export PATH="$PATH:/opt/go/bin"
