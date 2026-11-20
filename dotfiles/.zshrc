# Shortcut to this dotfiles
export DOTFILES=$HOME/$(dirname "$(dirname "$(stat -f %Y $HOME/.zshrc)")")

# Homebrew is set up in ~/.zprofile (login shells). Fall back to it here for
# interactive shells that aren't started from a login shell.
if [[ -z $HOMEBREW_PREFIX && -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p "$ZSH_CACHE_DIR"

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record the timestamp of each command
setopt hist_expire_dups_first # drop duplicates first when trimming the history
setopt hist_ignore_dups       # don't record a command twice in a row
setopt hist_ignore_space      # don't record commands starting with a space
setopt hist_verify            # show a history expansion before running it
setopt share_history          # share the history between running shells

# Directories
setopt auto_cd                # cd into a directory by typing its name
setopt auto_pushd             # make cd push the old directory onto the stack
setopt pushd_ignore_dups
setopt pushd_minus

# Misc
setopt interactive_comments   # allow comments in interactive shells
setopt long_list_jobs
unsetopt flow_control         # free Ctrl-S/Ctrl-Q
WORDCHARS=''                  # stop word movement and deletion at / . - etc.
export PAGER=${PAGER:-less}
export LESS=${LESS:--R}

# Colored ls (BSD ls on macOS uses LSCOLORS) and completion lists (LS_COLORS)
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS=${LS_COLORS:-'di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'}

# Completion: Homebrew's completions have to be in fpath before compinit
typeset -U fpath
[[ -n $HOMEBREW_PREFIX ]] && fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
zmodload -i zsh/complist
autoload -Uz compinit
() {
  local dump=$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION
  local -a fresh=($dump(N.mh-24))
  # Check for new completions and rebuild the dump at most once a day, use the
  # cached dump otherwise. -u: Homebrew's directories are group writable.
  if (( $#fresh )); then
    compinit -C -d "$dump"
  else
    compinit -u -d "$dump"
    touch "$dump"
  fi
  [[ $dump.zwc -nt $dump ]] || zcompile "$dump"
}
autoload -Uz bashcompinit && bashcompinit
setopt complete_in_word
setopt always_to_end
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# Key bindings: emacs mode, even if $EDITOR is vim (zsh would pick vi mode)
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^[[A' up-line-or-beginning-search    # Up: search history for the typed prefix
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search  # Down
bindkey '^[OB' down-line-or-beginning-search
bindkey '^[[H' beginning-of-line              # Home
bindkey '^[OH' beginning-of-line
bindkey '^[[F' end-of-line                    # End
bindkey '^[OF' end-of-line
bindkey '^[[3~' delete-char                   # Delete
bindkey '^[[Z' reverse-menu-complete          # Shift-Tab
bindkey '^[[1;5C' forward-word                # Ctrl-Right
bindkey '^[[1;5D' backward-word               # Ctrl-Left
bindkey '^[[1;3C' forward-word                # Option-Right
bindkey '^[[1;3D' backward-word               # Option-Left
bindkey '^[[3;5~' kill-word                   # Ctrl-Delete
bindkey ' ' magic-space                       # expand history (!!, !$) on space
bindkey '^X^E' edit-command-line              # edit the command line in $EDITOR
bindkey '^[m' copy-prev-shell-word
bindkey -M menuselect '^O' accept-and-infer-next-history
# Quote URLs while typing or pasting them
autoload -Uz bracketed-paste-magic url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

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

# Prompt: https://starship.rs, configured in ~/.config/starship.toml. The init
# script is cached and only regenerated when the starship binary changes.
if (( $+commands[starship] )); then
  () {
    local bin=${commands[starship]:A} cache=$ZSH_CACHE_DIR/starship.zsh line
    [[ -r $cache ]] && read -r line < "$cache"
    if [[ $line != "# $bin" ]]; then
      { print -r -- "# $bin"; "$bin" init zsh --print-full-init } >| "$cache"
    fi
  }
  source "$ZSH_CACHE_DIR/starship.zsh"
fi

# Local configuration
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# Plugins, installed with Homebrew. zsh-syntax-highlighting has to be sourced
# last: https://github.com/zsh-users/zsh-syntax-highlighting#faq
[[ -f $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
