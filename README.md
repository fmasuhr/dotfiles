# dotfiles

These are config files to set up my working environment.

## Prequisites

* Mac running macOS Sierra or OS X El Capitan
* Command Line Tools for Xcode: `xcode-select --install`, <https://developer.apple.com/downloads>
  or [Xcode](https://itunes.apple.com/us/app/xcode/id497799835)

## Installation

Run the following step in your terminal to install the complete environment

```sh
git clone git://github.com/fmasuhr/dotfiles ~/.dotfiles
cd ~/.dotfiles
make
```

To install applications/packages via Homebrew only:

```sh
cd ~/.dotfiles
make bundle
```

Only updating dotfiles via [stow](https://www.gnu.org/software/stow/):

```sh
cd ~/.dotfiles
make stow
```

## Theme

As theme for my console/editors i use [Solarized Dark](http://ethanschoonover.com/solarized).

* [Terminal](https://github.com/altercation/solarized/pull/314)
* [Sequel Pro](https://github.com/altercation/solarized/pull/133)

## Make your own customizations

Put customizations in dotfiles appended with `.local`:

* `~/.aliases.local`
* `~/.zshrc.local`
