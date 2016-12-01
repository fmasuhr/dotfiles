.PHONY: bundle stow

default: bundle stow

# Tasks

bundle:
	brew bundle

stow:
	stow -R dotfiles
