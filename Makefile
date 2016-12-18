.PHONY: default
default: softwareupdate bundle stow $(GOPATH)/bin $(GOPATH)/pkg $(GOPATH)/src ~/.rbenv/versions/2.2.5 ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User /usr/local/lib/node_modules/coffeelint /usr/local/lib/node_modules/eslint

# Tasks

.PHONY: bundle
bundle: | /usr/local/bin/brew
	brew update
	brew bundle
	brew cleanup
	brew cask cleanup

.PHONY: softwareupdate
softwareupdate:
	softwareupdate -ai --verbose

.PHONY: stow
stow: | bundle ~/.oh-my-zsh
	stow -t "$(HOME)" -R dotfiles

# Files

$(GOPATH)/bin: | stow
	mkdir -p $(GOPATH)/bin

$(GOPATH)/pkg: | stow
	mkdir -p $(GOPATH)/pkg

$(GOPATH)/src: | stow
	mkdir -p $(GOPATH)/src

~/.oh-my-zsh:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

~/.rbenv/versions/2.2.5: | bundle
	rbenv install 2.2.5
	rbenv global 2.2.5

~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package:
	mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
	curl "https://packagecontrol.io/Package%20Control.sublime-package" > "$@"

~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User:
	mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
	ln -s $(PWD)/sublime-settings "$@"

/usr/local/bin/brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

/usr/local/lib/node_modules/coffeelint: | bundle
	npm install -g coffeelint

/usr/local/lib/node_modules/eslint: | bundle
	npm install -g eslint
