NODE_VERSION = $(shell cat .nvmrc)
NPMS = coffeelint eslint npm

RUBY_VERSION = $(shell cat .ruby-version)
GEMS = bundler mdl rubocop scss_lint

GOPATH ?= ~/golang
ZSH ?= ~/.oh-my-zsh

FOLDER = $(GOPATH)/bin $(GOPATH)/pkg $(GOPATH)/src ~/.nvm ~/.terraform.d/plugin-cache

.PHONY: default
default: softwareupdate stow bundle npm gems $(FOLDER) ~/.nvm/versions/node/v$(NODE_VERSION) ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

# Tasks

.PHONY: bundle
bundle: | /usr/local/bin/brew
	brew update
	brew bundle
	mas upgrade
	brew cleanup

.PHONY: macos
macos:
	./macos

.PHONY: npm
npm: | bundle
	. "/usr/local/opt/nvm/nvm.sh"; \
		nvm use system; \
		npm install -g $(NPMS)

.PHONY: oh-my-zsh
oh-my-zsh: | $(ZSH)
	sh $(ZSH)/tools/upgrade.sh

.PHONY: gems
gems: | ~/.rbenv/versions/$(RUBY_VERSION)
	gem install $(GEMS)

.PHONY: softwareupdate
softwareupdate:
	softwareupdate -ai --verbose

.PHONY: stow
stow: | bundle oh-my-zsh
	stow -t "$(HOME)" -R dotfiles

# Files

$(FOLDER): | stow
	mkdir -p $@

$(ZSH):
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# First source the NVM functions to make it available to MAKE
~/.nvm/versions/node/v$(NODE_VERSION): | ~/.nvm bundle
	. "/usr/local/opt/nvm/nvm.sh"; \
		nvm install $(NODE_VERSION); \
		nvm alias default $(NODE_VERSION)

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
