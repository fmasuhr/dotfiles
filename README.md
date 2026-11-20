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

### SSH and commit signing with 1Password

SSH uses the keys stored in [1Password](https://developer.1password.com/docs/ssh/) (`~/.ssh/config` points `IdentityAgent` at its agent), and git signs every commit and tag with an SSH key from 1Password. After the first run of `dotfiles` (which installs 1Password), set this up once per machine:

1. In 1Password, open *Settings* → *Developer* and turn on *Use the SSH agent*.
2. Create or import an SSH key in 1Password and add its public key to GitHub twice under [*SSH and GPG keys*](https://github.com/settings/keys): once as an *Authentication key* and once as a *Signing key*.
3. Configure the public key for signing:

   ```sh
   # ~/.gitconfig.local
   [user]
     signingkey = ssh-ed25519 AAAA...
   ```

   If you use a different key per owner, set `user.signingkey` in that owner's file (e.g. `~/.gitconfig.fmasuhr`) instead.

Until a signing key is configured, every `git commit` fails with `either user.signingkey or gpg.ssh.defaultKeyCommand needs to be configured`. To not sign on a machine, turn it off locally:

```sh
# ~/.gitconfig.local
[commit]
  gpgsign = false
[tag]
  gpgsign = false
```

To verify signatures locally (`git log --show-signature`), list the trusted keys in `~/.ssh/allowed_signers`, one `email key` per line:

```sh
echo "your@email.com ssh-ed25519 AAAA..." >> ~/.ssh/allowed_signers
```

Machine-specific SSH hosts go into `~/.ssh/config.local`, which is included before the defaults and wins over them. On a machine that already has its own `~/.ssh/config`, move it there before running `dotfiles` (stow refuses to replace an existing file):

```sh
mv ~/.ssh/config ~/.ssh/config.local
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

If `STARRED_LIST_NAME` is empty, the script falls back to syncing every starred repository. If it is set, only repositories that are part of that list are synced.

## Customization

Make your own customizations locally by placing one of the following files into your home folder

* `~/.aliases.local`
* `~/.functions.local`
* `~/.gitconfig.local`
* `~/.ssh/config.local`
* `~/.zshrc.local`
* `~/.bin.local`

## Credits

* Mathias Bynens [macOS Defaults](https://mths.be/macos)
* <https://github.com/joeyhoer/starter>
