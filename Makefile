RUBY_VERSION = $(shell cat .ruby-version)

.PHONY: default
default: softwareupdate stow bundle npm gems $(GOPATH)/bin $(GOPATH)/pkg $(GOPATH)/src ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

# Tasks

.PHONY: bundle
bundle: | /usr/local/bin/brew
	brew update
	brew bundle
	mas upgrade
	brew cleanup
	brew cask cleanup

.PHONY: npm
npm: | bundle
	npm install -g coffeelint eslint

.PHONY: gems
gems: | ~/.rbenv/versions/$(RUBY_VERSION)
	gem install bundler rubocop

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

~/.rbenv/versions/$(RUBY_VERSION): | bundle
	rbenv install $(RUBY_VERSION)
	rbenv global $(RUBY_VERSION)

~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package:
	mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
	curl "https://packagecontrol.io/Package%20Control.sublime-package" > "$@"

~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User:
	mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
	ln -s $(PWD)/sublime-settings "$@"

/usr/local/bin/brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
