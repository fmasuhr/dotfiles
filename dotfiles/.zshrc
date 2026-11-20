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
  export EDITOR="code --wait"
fi

# Ruby configuration
eval "$(rbenv init -)"

# NVM configuration
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# https://github.com/creationix/nvm#zsh
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

export PATH="$HOME/.bin.local:$DOTFILES/bin:$PATH"

# Set personal aliases. For a full list of active aliases, run `alias`.
[[ -f $HOME/.aliases ]] && source $HOME/.aliases
[[ -f $HOME/.functions ]] && source $HOME/.functions

# Command-line tools: fzf, zoxide and direnv (installed via the Brewfile)
#
# Their `init` output only changes with the installed version, so it is cached
# in ~/.cache/zsh instead of running each tool on every new shell. The cache
# file is named after the resolved binary path, which contains the Homebrew
# version (/opt/homebrew/Cellar/<tool>/<version>/...), so it is regenerated
# after `brew upgrade`.
_dotfiles_source_init() {
  local tool=$1 bin=${commands[$1]:A}
  shift
  [[ -n $bin ]] || return
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$tool-${${bin:h:h}:t}.zsh
  if [[ ! -s $cache ]]; then
    mkdir -p "${cache:h}"
    rm -f "${cache:h}/$tool"-*.zsh(N)
    "$bin" "$@" >| "$cache"
  fi
  source "$cache"
}

# fzf: Ctrl-R searches the history, Ctrl-T inserts files, Alt-C changes into a
# directory, `**<Tab>` completes paths. fd lists the files, which respects
# .gitignore and includes dotfiles (except .git).
export FZF_DEFAULT_COMMAND="fd --type file --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type directory --hidden --exclude .git"
_fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
_fzf_compgen_dir() { fd --type directory --hidden --exclude .git . "$1" }
_dotfiles_source_init fzf --zsh

# zoxide: `z <part of a path>` jumps to a visited directory, `zi` picks one
# with fzf. `cd` is left unchanged.
_dotfiles_source_init zoxide init zsh

# direnv: loads and unloads the .envrc of a directory (after `direnv allow`)
_dotfiles_source_init direnv hook zsh

unfunction _dotfiles_source_init

# Local configuration
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
