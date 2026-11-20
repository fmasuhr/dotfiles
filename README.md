# dotfiles

These are my config files to set a working environment

## Getting Started

### Prequisites

* Mac with Apple silicon running a [supported macOS version](https://support.apple.com/en-us/HT201260)
* Command Line Tools for Xcode: `xcode-select --install`, [download](https://developer.apple.com/downloads)
  or use [Xcode](https://itunes.apple.com/us/app/xcode/id497799835)

### Installation

Clone the GitHub repository somewhere (i preferer `~/.dotfiles`) on to your machine

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

### Shell

The shell is plain [zsh](https://www.zsh.org) without a framework, set up in `~/.zprofile` (Homebrew, for login shells) and `~/.zshrc`:

* Prompt: [Starship](https://starship.rs), configured in `~/.config/starship.toml`. It shows the path and the git branch (a red `*` if there are changes) and, on the right, the exit code of a failed command and the time.
* Plugins, installed with Homebrew: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) (accept a suggestion with `→` or `End`) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
* `↑`/`↓` search the history for commands starting with what is already typed, a shared history of 10000 entries is kept in `~/.zsh_history` (commands starting with a space are not recorded).
* Completion is case-insensitive with a menu. New completions (e.g. of a newly installed formula) are picked up once a day; to pick them up right away, run `rm ~/.cache/zsh/zcompdump-*` and open a new shell.

Machines that used the earlier oh-my-zsh setup can remove it once: `rm -rf ~/.oh-my-zsh ~/.zcompdump*`.

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
* `~/.zprofile.local` (login shells, e.g. environment variables)
* `~/.zshrc.local`
* `~/.bin.local`

## Credits

* Mathias Bynens [macOS Defaults](https://mths.be/macos)
* <https://github.com/joeyhoer/starter>
