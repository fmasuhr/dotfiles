.PHONY: bundle stow

default: bundle stow

# Tasks

bundle: /usr/local/bin/brew
	brew bundle

stow: ~/.oh-my-zsh
	stow -R dotfiles

# Files

/usr/local/bin/brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

~/.oh-my-zsh:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
