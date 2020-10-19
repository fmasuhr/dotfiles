NODE_VERSION = $(shell cat .nvmrc)
NPMS = coffeelint eslint npm

RUBY_VERSION = $(shell cat .ruby-version)
GEMS = bundler:1.17.3 mdl rubocop scss_lint

GOPATH ?= ~/golang
ZSH ?= ~/.oh-my-zsh

FOLDER = ~/github $(GOPATH)/bin $(GOPATH)/pkg $(GOPATH)/src ~/.nvm ~/.terraform.d/plugin-cache

SUBLIME_PATH = $(HOME)/Library/Application\ Support/Sublime\ Text\ 3
# Find all packages and adjust to sublime packages path
SUBLIME_PACKAGES = $(shell find ./sublime-packages -depth 1 -type d -print0 | xargs -0 -n1 basename | while read n; do echo $(SUBLIME_PATH)/Packages/$${n}; done | sed 's: :\\ :g' )

.PHONY: default
default: softwareupdate stow bundle npm gems $(FOLDER) ~/.nvm/versions/node/v$(NODE_VERSION) $(SUBLIME_PACKAGES)

# Tasks

.PHONY: bundle
bundle: | /usr/local/bin/brew
	brew update
	brew bundle
	mas upgrade
	brew cleanup

.PHONY: macos
macos:
	./macos/macos

.PHONY: npm
npm: | bundle
	. "/usr/local/opt/nvm/nvm.sh"; \
		nvm use system; \
		npm install -g $(NPMS)

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

# First source the NVM functions to make it available to MAKE
~/.nvm/versions/node/v$(NODE_VERSION): | ~/.nvm bundle
	. "/usr/local/opt/nvm/nvm.sh"; \
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
