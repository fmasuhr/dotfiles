.PHONY: bundle stow

default: bundle stow ~/.rbenv/versions/2.2.4 ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

# Tasks

bundle: /usr/local/bin/brew
	brew bundle

stow: bundle ~/.oh-my-zsh
	stow -R dotfiles

# Files

~/.oh-my-zsh:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

~/.rbenv/versions/2.2.4: | bundle
	rbenv install 2.2.4
	rbenv global 2.2.4
	rbenv rehash

~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package:
	mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
	curl "https://packagecontrol.io/Package%20Control.sublime-package" > "$@"

~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User:
	mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
	ln -s $(PWD)/sublime-settings "$@"

/usr/local/bin/brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
