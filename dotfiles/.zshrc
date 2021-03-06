# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Shortcut to this dotfiles
export DOTFILES=$HOME/$(dirname "$(dirname "$(stat -f %Y $HOME/.zshrc)")")

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="af-magic"

# https://github.com/ohmyzsh/ohmyzsh/issues/6835
ZSH_DISABLE_COMPFIX=true

# Updates will be triggered manually
DISABLE_AUTO_UPDATE=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh

# User configuration

export HOMEBREW_NO_ANALYTICS=1
export PATH="$HOME/.bin.local:$DOTFILES/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Go Lang configuration
export GO111MODULE=on
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$GOROOT/bin:$PATH
export PATH=$GOPATH/bin:$PATH

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="subl -w"
fi

# Fix terraform 0.12
# https://github.com/hashicorp/terraform/issues/23615#issuecomment-610944963
ulimit -n 1024

# Rubygems configuation
export RUBYOPT=rubygems
eval "$(rbenv init -)"

[[ -f $HOME/.gemrc.local ]] && export GEMRC=$HOME/.gemrc.local

# NVM configuration
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# https://github.com/creationix/nvm#zsh
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use --silent
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default --silent
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Set personal aliases. For a full list of active aliases, run `alias`.
[[ -f $HOME/.aliases ]] && source $HOME/.aliases
[[ -f $HOME/.functions ]] && source $HOME/.functions

# Local configuration
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
