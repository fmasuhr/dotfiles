NODE_VERSION = $(shell cat .nvmrc)
NPMS = npm
NVM_DIR ?= $(HOME)/.nvm

RUBY_VERSION = $(shell cat .ruby-version)
GEMS = bundler

ZSH ?= ~/.oh-my-zsh

FOLDER = ~/github ~/.terraform.d/plugin-cache

.PHONY: default
default: softwareupdate stow bundle npm gems $(FOLDER) $(NVM_DIR)/versions/node/v$(NODE_VERSION)

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

.PHONY: ohmyzsh
ohmyzsh: | $(ZSH) $(ZSH)/custom/themes/af-magic.zsh-theme
	sh $(ZSH)/tools/upgrade.sh

.PHONY: gems
gems: | ~/.rbenv/versions/$(RUBY_VERSION)
	gem install $(GEMS)

.PHONY: softwareupdate
softwareupdate:
	softwareupdate -ai --verbose

.PHONY: stow
stow: | bundle ohmyzsh
	stow -t "$(HOME)" -R dotfiles

# Files

$(FOLDER): | stow
	mkdir -p $@

$(ZSH)/custom/themes/af-magic.zsh-theme:
	ln -s "$(DOTFILES)/themes/$$(basename "$@")" "$@"

$(ZSH):
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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

/usr/local/bin/brew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
