# Import aliases
if [ -e $HOME/.aliases ]; then
    source $HOME/.aliases
fi

# Change prompt
eval "$(starship init zsh)"

# Add syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add rust binaries to the path
export PATH="$PATH:/root/.cargo/bin"

# Add go binaries to the path
export PATH="$PATH:/root/go/bin"
