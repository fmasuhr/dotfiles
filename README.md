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

### Command-line tools

The `Brewfile` installs these tools in addition to the standard ones. Standard commands like `ls`, `cat`, `find`, `grep` and `cd` are not aliased to them, so scripts and existing habits keep working.

* [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) searches file contents, respecting `.gitignore`. It replaces `the_silver_searcher` (`ag`).
* [fd](https://github.com/sharkdp/fd) finds files by name, respecting `.gitignore`.
* [fzf](https://github.com/junegunn/fzf) is a fuzzy finder, with its shell integration enabled in `.zshrc`:
  * `Ctrl-R` searches the shell history
  * `Ctrl-T` inserts the selected files or directories into the command line
  * `Alt-C` changes into the selected directory
  * `**<Tab>` completes paths, e.g. `vim **<Tab>`

  Files and directories are listed with `fd`, including hidden ones but not `.git`.
* [zoxide](https://github.com/ajeetdsouza/zoxide) remembers visited directories: `z <part of a path>` jumps to the best match, `zi` picks one with fzf.
* [direnv](https://direnv.net) loads the environment variables of an `.envrc` file when you enter its directory and unloads them when you leave. Run `direnv allow` once per `.envrc` (and after each change to it).
* [bat](https://github.com/sharkdp/bat) is a `cat` with syntax highlighting and Git changes, e.g. `bat file.rb` (`bat --paging=never` prints without a pager).
* [eza](https://eza.rocks) is an `ls` with colours and Git status, used by these aliases:
  * `ll` lists files in long format with their Git status, directories first
  * `la` like `ll`, including hidden files
  * `lt` shows a tree two levels deep, without files ignored by Git
* [delta](https://github.com/dandavison/delta) (`git-delta`) is the pager for `git diff`, `git log -p`, `git show` and `git add -p`, with syntax highlighting. Press `n` and `N` to jump between files.

The shell integrations of fzf, zoxide and direnv are cached in `~/.cache/zsh` to keep the shell startup fast, and regenerated when a tool is upgraded. Remove the directory to regenerate them manually.

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
