[![Build Status](https://travis-ci.org/fmasuhr/dotfiles.svg?branch=master)](https://travis-ci.org/fmasuhr/dotfiles)
[![Issue Count](https://codeclimate.com/github/fmasuhr/dotfiles/badges/issue_count.svg)](https://codeclimate.com/github/fmasuhr/dotfiles)

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

Use [make](https://www.gnu.org/software/make/) inside the cloned repository to setup the complete environment

```sh
cd ~/.dotfiles
make
```

This command can be also used later on to update the environment e.g. on a daily base.

If necessary you can also install Homebrew packages only

```sh
make bundle
```

Or trigger an update of dotfiles via [stow](https://www.gnu.org/software/stow/)

```sh
make stow
```

### macOS Preferences

Setting up a new Mac and all preferences the way i am used to i use the `defaults` command.
This is not included in the environment setup as it is not necessary to execute this regulary

```sh
make macos
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
* <https://github.com/joeyhoer/starter>
