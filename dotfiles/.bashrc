# Shortcut to this dotfiles
export DOTFILES=$HOME/$(dirname "$(dirname "$(stat -f %Y $HOME/.zshrc)")")

export PATH="$DOTFILES/bin.local:$DOTFILES/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
