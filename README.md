# dotfiles

These are config files to set up my working environment.

## Installation

Run the following commands in your terminal.

```sh
git clone git://github.com/fmasuhr/dotfiles ~/.dotfiles
```

### Homebrew

Instal Command Line Tools for Xcode: `xcode-select --install`, https://developer.apple.com/downloads or [Xcode](https://itunes.apple.com/us/app/xcode/id497799835)

Get [Homebrew](http://brew.sh):
```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Instal all missing applications/packages:
```sh
cd ~/.dotfiles
brew bundle
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
