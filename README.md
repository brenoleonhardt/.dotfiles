# Dotfiles playbook

A Perl script that automates the complete setup of my developer environment.

## Usage

1. **Clone this repository:**

```sh
git clone git@github.com:brenoleonhardt/.dotfiles.git ~/.dotfiles &&
  perl ~/.dotfiles/playbook.pl
```

## Features

- `package installation`: via `pacman`
- `dotfile management`: using GNU Stow
- `system configuration`: `/etc` sync & systemd services
- `repository cloning`: dotfiles, notes, passwords, custom software
- `language runtimes and tools`: node/yarn (asdf), go, rust, perl, etc
- `custom packages`: makepkg + custom pacman database
- `key management`: gpg and ssh-agent
- `idempotent and debug-friendly`: safe to re-run, with debug output

## Directory structure

- `playbook.pl` — perl script that orchestrates all tasks.
- `etc/` — system configuration files to be copied to `/etc`, `/etc/udev/rules.d/`, etc.
- `home/` — user dotfiles and configuration (to be stowed into `$HOME`).
- `makepkg/` — custom and AUR package build scripts.

## Requirements

- **git**
- **perl** (with standard modules)
- **pacman** (arch linux)
- **gpg** (for key management)
- **systemd** (for service management)
- ssh access to the target host - user and root (even on localhost)
