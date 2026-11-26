# Login shells (every new Terminal tab on macOS). Runs before ~/.zshrc and
# after /etc/zprofile, whose path_helper would otherwise reorder the PATH.

# Homebrew: PATH, MANPATH, INFOPATH, fpath and HOMEBREW_PREFIX
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

export HOMEBREW_NO_ANALYTICS=1
export DO_NOT_TRACK=1

# Local configuration
[[ -f $HOME/.zprofile.local ]] && source $HOME/.zprofile.local
