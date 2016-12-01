.PHONY: bundle stow

default: bundle stow ~/.rbenv/versions/2.2.4 /usr/local/lib/node_modules/coffee-script /usr/local/lib/node_modules/coffeelint

# Tasks

bundle: /usr/local/bin/brew
	brew bundle

stow: bundle ~/.oh-my-zsh
	stow -R dotfiles

# Files

~/.oh-my-zsh:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

~/.rbenv/versions/2.2.4:
	rbenv install 2.2.4
	rbenv global 2.2.4
	rbenv rehash

/usr/local/bin/brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

/usr/local/lib/node_modules/coffee-script: # "bundle" cant be a dependency. It is phony and will trigger target everytime
	npm install -g coffee-script

/usr/local/lib/node_modules/coffeelint: # "bundle" cant be a dependency. It is phony and will trigger target everytime
	npm install -g coffeelint
