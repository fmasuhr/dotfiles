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

Configure email as this is done per repository.

```sh
# ~/.gitconfig.local
[user]
  email = your@email.com

[includeIf "hasconfig:remote.*.url:git@github.com:fmasuhr/**"]
  path = ~/.gitconfig.fmasuhr
[includeIf "hasconfig:remote.*.url:https://github.com/fmasuhr/**"]
  path = ~/.gitconfig.fmasuhr
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

### Projects

The `bin/projects` script helps to sync my starred GitHub repositories into a local folder and keeps them up to date. It will clone repositories that do not exist locally and pull changes for anything that already exists.

```sh
bin/projects
```

By default it syncs all starred repositories in `~/github`. If you want to sync only a specific starred list you can configure a list name and the script will use that list instead.

```sh
# ~/.zshrc.local
export PROJECTS_PATH=~/github
export STARRED_LIST_NAME="my-projects"
```

If `STARRED_LIST_NAME` is empty, the script falls back to syncing every starred repository. If it is set, only repositories that are part of that list are synced. The script also exits early with a helpful message if no repositories are found and prints how many repositories it discovered before syncing.

This keeps local workspaces in sync with the repositories i have starred while still allowing a small filtered set for specific projects.

### macOS Preferences

Setting up a new Mac and all preferences the way i am used to i use the `defaults` command.
This is not included in the environment setup as it is not necessary to execute this regulary

```sh
dotfiles macos
```

To only execute specific preferences e.g. of ther Terminal app you can use:

```sh
dotfiles macos/terminal
```

## Customization

Make your own customizations locally by placing one of the following files into your home folder

* `~/.aliases.local`
* `~/.functions.local`
* `~/.gitconfig.local`
* `~/.zshrc.local`
* `~/.bin.local`

## Credits

* Mathias Bynens [macOS Defaults](https://mths.be/macos)
* <https://github.com/altercation/solarized>
* <https://github.com/joeyhoer/starter>
