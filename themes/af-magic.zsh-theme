# Custom theme based on af-magic.zsh-theme
# https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

# primary prompt
PS1='%{$fg[blue]%}%~$(git_prompt_info) %{$fg_bold[blue]%}%(!.#.»)%{$reset_color%} '

# right prompt
RPS1='%(?..%{$fg[red]%}%? ↵%{$reset_color%}) %{$fg_bold[blue]%}%*%{$reset_color%}'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
