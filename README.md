# dotfiles

These are my config files to set a working environment

## Getting Started

### Prequisites

* Mac running OS X El Capitan (10.11) or higher
* Command Line Tools for Xcode: `xcode-select --install`, [download](https://developer.apple.com/downloads)
  or use [Xcode](https://itunes.apple.com/us/app/xcode/id497799835)

### Installation

Clone the GitHub repository somewhere (i preferer `~/.dotfiles`) on to your machine

```sh
git clone git://github.com/fmasuhr/dotfiles ~/.dotfiles
```

For the inital setup you need to execute the `dotfiles` executable once inside the cloned repository to setup the complete environment

```sh
cd ~/.dotfiles
./bin/dotfiles
```

## Features

After the first initialization there is a shortcut available which can be used to later on to update the complete environment (which should be done e.g. on a daily base)

```sh
dotfiles
```

If necessary you can also install Homebrew packages only

```sh
dotfiles bundle
```

Or trigger an update of dotfiles via [stow](https://www.gnu.org/software/stow/)

```sh
dotfiles stow
```

### macOS Preferences

Setting up a new Mac and all preferences the way i am used to i use the `defaults` command.
This is not included in the environment setup as it is not necessary to execute this regulary

```sh
dotfiles macos
```

### Theme

As theme for my console/editors i use [Solarized Dark](http://ethanschoonover.com/solarized).
They need to be installed manually

* [Terminal](https://github.com/altercation/solarized/pull/314)
* [Sequel Pro](https://github.com/altercation/solarized/pull/133)

## Customization

Make your own customizations locally by placing one of the following files into your home folder

* `~/.aliases.local`
* `~/.functions.local`
* `~/.zshrc.local`

## Credits

* Mathias Bynens [macOS Defaults](https://mths.be/macos)
* <https://github.com/altercation/solarized>
* <https://github.com/joeyhoer/starter>
