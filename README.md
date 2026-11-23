# dotfiles

These are my config files to set a working environment

## Getting Started

### Prerequisites

* Mac with Apple silicon running a [supported macOS version](https://support.apple.com/en-us/HT201260)
* Command Line Tools for Xcode: `xcode-select --install`, [download](https://developer.apple.com/download/all/)
  or use [Xcode](https://apps.apple.com/app/xcode/id497799835)

### Installation

Clone the GitHub repository somewhere on your machine (I prefer `~/.dotfiles`)

```sh
git clone https://github.com/fmasuhr/dotfiles.git ~/.dotfiles
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

For the initial setup, run the `dotfiles` executable once inside the cloned repository to set up the complete environment

```sh
cd ~/.dotfiles
./bin/dotfiles
```

## Features

After the first initialization the `dotfiles` command is on your `PATH` and updates the complete environment (run it regularly, e.g. daily)

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

If `STARRED_LIST_NAME` is empty, the script falls back to syncing every starred repository. If it is set, only repositories that are part of that list are synced.

## Customization

Make your own customizations locally by placing one of the following files into your home folder

* `~/.aliases.local`
* `~/.functions.local`
* `~/.gitconfig.local`
* `~/.zshrc.local`

Executables in the directory `~/.bin.local` are on the `PATH`, before the ones in `bin/`.

## Credits

* Mathias Bynens' [dotfiles](https://github.com/mathiasbynens/dotfiles), where some of the aliases come from
* <https://github.com/joeyhoer/starter>
