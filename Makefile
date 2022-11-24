NODE_VERSION = $(shell cat .nvmrc)
NPMS = eslint npm stylelint
NVM_DIR ?= $(HOME)/.nvm

RUBY_VERSION = $(shell cat .ruby-version)
GEMS = bundler mdl rubocop

GOPATH ?= ~/golang
ZSH ?= ~/.oh-my-zsh

FOLDER = ~/github $(GOPATH)/bin $(GOPATH)/pkg $(GOPATH)/src ~/.terraform.d/plugin-cache

SUBLIME_PATH = $(HOME)/Library/Application\ Support/Sublime\ Text\ 3
# Find all packages and adjust to sublime packages path
SUBLIME_PACKAGES = $(shell find ./sublime-packages -depth 1 -type d -print0 | xargs -0 -n1 basename | while read n; do echo $(SUBLIME_PATH)/Packages/$${n}; done | sed 's: :\\ :g' )

.PHONY: default
default: softwareupdate stow bundle npm gems $(FOLDER) $(NVM_DIR)/versions/node/v$(NODE_VERSION) $(SUBLIME_PACKAGES)

# Tasks

.PHONY: bundle
bundle: | /usr/local/bin/brew
	brew update
	brew bundle
	mas upgrade
	brew cleanup

.PHONY: macos
macos: macos/*

.PHONY: macos/*
macos/*:
	$@

.PHONY: npm
npm: | nvm
	. $(NVM_DIR)/nvm.sh; \
		nvm use system; \
		npm install --location=global $(NPMS)

.PHONY: nvm
nvm: $(NVM_DIR)
	cd $(NVM_DIR); \
		git fetch --tags origin; \
		git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`; \
		. $(NVM_DIR)/nvm.sh

.PHONY: oh-my-zsh
oh-my-zsh: | $(ZSH) $(ZSH)/custom/themes/af-magic.zsh-theme
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

$(ZSH)/custom/themes/af-magic.zsh-theme:
	ln -s "$(DOTFILES)/themes/$$(basename "$@")" "$@"

$(ZSH):
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

$(NVM_DIR):
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

$(NVM_DIR)/versions/node/v$(NODE_VERSION): | nvm
	. $(NVM_DIR)/nvm.sh; \
		nvm install $(NODE_VERSION); \
		nvm alias default $(NODE_VERSION)

.PHONY: ~/.rbenv/versions/$(RUBY_VERSION)
~/.rbenv/versions/$(RUBY_VERSION): | bundle
	rbenv install --skip-existing $(RUBY_VERSION)
	rbenv global $(RUBY_VERSION)

$(SUBLIME_PATH)/Installed\ Packages/Package\ Control.sublime-package:
	mkdir -p $(SUBLIME_PATH)/Installed\ Packages
	curl "https://packagecontrol.io/Package%20Control.sublime-package" > "$@"

$(SUBLIME_PACKAGES): | $(SUBLIME_PATH)/Installed\ Packages/Package\ Control.sublime-package
	mkdir -p $(SUBLIME_PATH)/Packages
	ln -s "$(DOTFILES)/sublime-packages/$$(basename "$@")" "$@"

/usr/local/bin/brew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
