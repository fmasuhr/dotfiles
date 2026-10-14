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
export DO_NOT_TRACK=1

eval "$(/opt/homebrew/bin/brew shellenv)"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="subl -w"
fi

# Fix terraform 0.12
# https://github.com/hashicorp/terraform/issues/23615#issuecomment-610944963
ulimit -n 1024

export PATH="$HOME/.bin.local:$DOTFILES/bin:$PATH"

# Set personal aliases. For a full list of active aliases, run `alias`.
[[ -f $HOME/.aliases ]] && source $HOME/.aliases
[[ -f $HOME/.functions ]] && source $HOME/.functions

# Local configuration
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# BEGIN sb-infra-general shell setup
# Managed by `mise run setup-shell` — re-running replaces this block.
source <(mise completion zsh)
autoload -Uz bashcompinit && bashcompinit
complete -o nospace -C terraform terraform
# END sb-infra-general shell setup
eval "$(mise activate zsh)"
