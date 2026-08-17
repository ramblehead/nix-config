# nix-config

My personal Nix and NixOS configuration - one repository that
declaratively manages every machine I use.

## Purpose

This repository is the single source of truth for:

| Host     | System      | Role                                                                  |
|----------|-------------|-----------------------------------------------------------------------|
| `vostok` | NixOS 26.05 | main workstation (GNOME + niri, Steam, printing, Samba, VMs, backups) |
| `glider` | Debian      | laptop, managed via standalone home-manager                           |
| `qt-dl1` | Debian      | desktop, managed via standalone home-manager                          |

One `git pull` plus one rebuild command reproduces a machine's
software, services, and configuration. Dotfiles live in a git submodule
and are symlinked from the live checkout at `~/box/nix-config`, so
editing a dotfile takes effect immediately - no rebuild needed.

## Repository layout

```
flake.nix                  flake outputs: hosts, home-manager configs, formatter
nixos/hosts/<host>/        NixOS system configuration per host
hm/                        home-manager modules (users, hosts, programs)
software/selections/       shared package sets grouped by purpose
overlays/                  package overlays (mc with nix syntax highlighting)
lib/                       helper functions (dotfiles path resolution)
dotfiles/                  dotfiles submodule (emacs, alacritty, wezterm, mc, ...)
utils/maintenance/         scripts for submodule and git hygiene
```

## Common commands

```
just rebuild                    # nixos-rebuild switch --flake . (NixOS host)
just update                     # nix flake update
just check                      # nix flake check
just fmt                        # format nix files (alejandra via treefmt)
just gc                         # garbage-collect the nix store
just hm-switch-host <hostname>  # switch root home-manager on a Debian host
just hm-switch-user <username>  # switch user home-manager on a Debian host
```

## Fresh clone

```sh
git clone --recurse-submodules git@github.com:ramblehead/nix-config.git ~/box/nix-config
```

Or, if the clone is already done, populate the submodules with
`utils/maintenance/git-populate-submodules`.

Requires Nix >= 2.28 (needed for `inputs.self.submodules`).

## Commit conventions

Commit messages use conventional prefixes with a host or area scope,
e.g. `feat(vostok): add claude-monitor`,
`fix(sudo): guard secure_path appends`.
See `AGENTS.md` for the full convention and repository rules.
