# Agent Instructions

Guidance for AI coding agents working in this repository.

## Backlog

Open work is tracked in `BACKLOG.md` (create it if it doesn't exist): pick up items from there, add follow-up work you can't finish, and remove items in the PR that completes them.

## Pull requests

- Always assign `fmasuhr` to every pull request you open.
- Keep unrelated changes in separate pull requests (e.g. CI or tooling fixes go into their own PR, opened before the PR that needs them). One topic per pull request keeps the review easy.
- Pull requests are merged with merge commits, not squash or rebase.
- In the description, say what you verified and how, and list what you could not test (see [Applying changes](#applying-changes)).

## Applying changes

Nothing is deployed automatically. A change reaches a machine when `dotfiles` (`bin/dotfiles`, which runs `make` in this repository) is run on it, which is done regularly, e.g. daily. Review changes with that in mind:

- The setup targets macOS on Apple silicon only (Homebrew in `/opt/homebrew`, `stow -f %Y`, `softwareupdate`, `mas`, casks). Don't add Linux or Intel fallbacks unless asked.
- Every `make` target must be idempotent and safe to re-run on a machine that is already set up, and must also work for the first run on a fresh Mac (see `README.md`, *Installation*).
- When something is renamed, moved or removed (e.g. a dotfile, a tool, a theme), think about machines that already have the old setup: `stow -R` removes links to files that are gone from `dotfiles/`, but files written by installers (e.g. `~/.oh-my-zsh`, `~/.nvm`, `~/.rbenv`) stay. Mention the manual cleanup in the pull request, or add it to `README.md` if it is needed on every machine.
- Agents usually run in a Linux container without macOS, Homebrew or the user's shell. Verify what you can there (syntax checks, `shellcheck`, `markdownlint-cli2`, running a script with mocked commands) and list the rest in the pull request as untested, with the commands to check it on a Mac.

## Repository layout

- `dotfiles/` holds the files linked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/) (`make stow`, i.e. `stow -t "$HOME" -R dotfiles`). Its directory structure mirrors `$HOME`, so `dotfiles/.config/git/config` becomes `~/.config/git/config`. New config files go here. Stow links a whole directory if it doesn't exist in `$HOME` yet, so directories that hold other files (like `~/.ssh` with keys and `known_hosts`) are created by the `Makefile` before `stow`.
- `bin/` holds executables. `.zshrc` puts it on the `PATH` (via `$DOTFILES`, the path of this repository, derived from the `~/.zshrc` symlink). `bin/dotfiles` runs `make` with its arguments; `bin/projects` syncs the starred GitHub repositories into `~/github` (see `README.md`).
- `Makefile` sets up the whole environment; `default` runs every step. Targets that are only run for their side effect are `.PHONY`; targets that create a file or directory are named after it, so they only run when it is missing.
- `Brewfile` lists everything installed with Homebrew: `brew` formulae first, then other taps with their formulae and casks, then `cask`s, then Mac App Store apps (`mas`), each group sorted alphabetically. A formula that is only there as a dependency of another one gets a trailing comment saying so (e.g. `# required by rbenv and ruby-build`).
- `.nvmrc` and `.ruby-version` pin the global default versions of Node.js and Ruby. Use full versions (e.g. `26.13.1`), since the `Makefile` checks for an installed directory of exactly that name. Keep them on supported releases (Node.js LTS, a maintained Ruby series).
- `themes/` holds the zsh prompt theme.
- Local, machine-specific configuration is never committed: each config file sources its `*.local` counterpart in `$HOME` if it exists (`~/.zshrc.local`, `~/.aliases.local`, `~/.functions.local`, `~/.gitconfig.local`, `~/.ssh/config.local`, `~/.bin.local`), as listed in `README.md`, *Customization*. Keep these hooks when changing a file, and add one for new files where it makes sense.
- Never commit secrets or personal email addresses. Tokens come from environment variables (e.g. `${NPM_GITHUB_TOKEN}` in `.npmrc`), set in a `*.local` file.
- `user.email = (none)` in `.gitconfig` is on purpose: the email is set per repository or per owner (see `README.md`), and `bin/projects` checks for that value to ask which email to configure after a clone. Keep both in sync.

## Conventions

- Keep shell startup fast: prefer native zsh and lazy or cached initialisation over plugins and subprocesses that run on every new shell. Check the startup time of a change to `.zshrc` (e.g. `hyperfine 'zsh -i -c exit'`) where you can.
- Scripts in `bin/` are bash (`#!/usr/bin/env bash`), quote their variables and pass `shellcheck`. zsh files (`.zshrc`, `.aliases`, `.functions`, `themes/*.zsh-theme`) are zsh, not POSIX sh.
- Every user-facing change (a new command, tool, setting or local override) is documented in `README.md` in the same pull request.
- Comments explain why something is configured when it isn't obvious, with a link to the source where useful (e.g. an upstream issue). Remove workarounds once the issue they work around is fixed.
- Prefer tools installed with Homebrew over `curl | sh` installers. If an installer is unavoidable, pin it to a release tag instead of a moving branch like `master`.

## Checks

Run before pushing:

```sh
markdownlint-cli2
shellcheck bin/*
git ls-files -z -- '*.zsh' '*.zsh-theme' '*.zshrc' '*.zshenv' '*.zprofile' '*.aliases' '*.functions' | xargs -0 -n 1 zsh -n
zizmor .
```

- The `Lint` workflow (`.github/workflows/lint.yml`) runs the checks above on every push. The `Brewfile` workflow (`.github/workflows/brewfile.yml`) checks the `Brewfile` on a macOS runner (see below).
- The bash scripts in `bin/` are checked with [ShellCheck](https://www.shellcheck.net/) (`brew install shellcheck`; preinstalled on the CI runner). Fix findings rather than disabling them; if a `# shellcheck disable=` is unavoidable, add a comment giving the reason.
- zsh files can't be checked by ShellCheck, so CI only checks their syntax with `zsh -n`, one file per call (`zsh -n a b` checks `a` only and passes `b` as an argument). The `git ls-files` patterns cover the zsh files by name; add a pattern when adding a zsh file with another name.
- The workflows and `.github/dependabot.yml` are audited with [zizmor](https://docs.zizmor.sh/). It is pinned in `requirements-lint.txt`, which Dependabot (`pip` in `.github/dependabot.yml`, with a cooldown of 7 days) keeps up to date, and installed with `actions/setup-python` in CI. Install the pinned version locally with `pip install -r requirements-lint.txt` (or `brew install zizmor`). Without `GH_TOKEN` set, run `zizmor --offline .`; CI passes the job's token for the online audits.
- The `Brewfile` workflow runs on pushes that change the `Brewfile` or the workflow, weekly (formulae and casks can be removed upstream), and on demand (`workflow_dispatch`). It checks that the `Brewfile` parses and that every tap, formula and cask in it exists (`brew bundle list`, `brew bundle install` of only its `tap` lines, so `trusted: true` applies, and `brew info`), without installing anything. `mas` entries are not checked, since runners have no App Store login. The repository is public, so the macOS runner costs no Actions minutes. Check it locally with `brew bundle list --all` and `brew bundle check --verbose` (which lists what isn't installed).
- Markdown files are linted with [`markdownlint-cli2`](https://github.com/DavidAnson/markdownlint-cli2), using the `DavidAnson/markdownlint-cli2-action`. The action bundles a fixed markdownlint-cli2 version and Dependabot updates it with the other actions; run it locally with `markdownlint-cli2` (install it with `brew install markdownlint-cli2` or `npm install -g markdownlint-cli2`). The local version isn't pinned, so a newer one may flag something before CI does. The config is `.markdownlint-cli2.yaml`: it lints every `*.md` file not ignored by git, with `MD013` (line length) disabled. Disable further rules there only with a comment giving the reason.
- GitHub Actions in the workflows are pinned to the full commit SHA of a release, with its full version tag as a comment (e.g. `uses: actions/checkout@<sha> # v7.0.1`), so a moved or compromised tag can't change what runs. Resolve the SHA of the tag's commit (dereference annotated tags, e.g. `git ls-remote --tags https://github.com/<owner>/<repo>.git 'refs/tags/<tag>^{}'`), and pin new actions the same way. Dependabot (`github-actions` in `.github/dependabot.yml`, with a cooldown of 7 days) updates the SHA and the comment together.
- Every `actions/checkout` step sets `persist-credentials: false`, so the job's token isn't left in `.git/config` for later steps.
- Every workflow sets `permissions: {}` at the top level, and every job grants itself only the token permissions it needs in its own `permissions:` block (`contents: read` for checkout). Every grant other than `contents: read` gets a trailing comment saying what it is for.
