GEMS = bundler

ZSH ?= $(HOME)/.oh-my-zsh

FOLDER = ~/github ~/.terraform.d/plugin-cache

.PHONY: default
default: softwareupdate stow bundle mise gems $(FOLDER)

# Tasks

.PHONY: bundle
bundle: | /opt/homebrew/bin/brew
	brew update
	brew bundle
	mas upgrade
	brew cleanup

.PHONY: mise
mise: | stow
	mise install

.PHONY: ohmyzsh
ohmyzsh: | $(ZSH) $(ZSH)/custom/themes/af-magic.zsh-theme
	sh $(ZSH)/tools/upgrade.sh

.PHONY: gems
gems: | mise
	mise exec -- gem install $(GEMS)

.PHONY: softwareupdate
softwareupdate:
	softwareupdate -ai --verbose

.PHONY: stow
stow: | bundle ohmyzsh ~/.config/mise
	stow -t "$(HOME)" -R dotfiles

# Files

$(FOLDER): | stow
	mkdir -p $@

$(ZSH)/custom/themes/af-magic.zsh-theme:
	ln -sf "$(DOTFILES)/themes/$$(basename "$@")" "$@"

$(ZSH):
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Created before stow, so stow links config.toml instead of the whole directory
# and files mise writes there (e.g. config.local.toml) stay out of this repository
~/.config/mise:
	mkdir -p $@

/opt/homebrew/bin/brew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
