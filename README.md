# dotfiles

These are config files to set up my working environment.

## Installation

Run the following commands in your terminal.

```sh
git clone git://github.com/fmasuhr/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

### Dotfiles

Use [stow](https://www.gnu.org/software/stow/) to install dotfiles:

```sh
cd ~/.dotfiles
stow dotfiles
```

## Make your own customizations

Put customizations in dotfiles appended with `.local`:

  * `~/.aliases.local`
  * `~/.zshrc.local`
