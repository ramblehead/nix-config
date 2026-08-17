# AGENTS.md

Guidance for AI agents (and humans) working in this repository.

## What this is

Personal Nix flakes configuration for:

- **vostok** - NixOS 26.05 workstation (GNOME + niri, the primary host)
- **glider**, **qt-dl1** - Debian hosts managed via standalone
  home-manager (root + `rh@` configs, nixGL)

Layout:

- `nixos/hosts/<host>/` - NixOS system configs
- `hm/users/`, `hm/hosts/`, `hm/programs/` - home-manager modules
- `software/selections/` - shared package sets; add packages here, not
  ad hoc in host configs
- `overlays/`, `lib/` - custom mc overlay (nix.syntax) and helpers
- `dotfiles/` - git submodule, linked into the live checkout at
  `~/box/nix-config`

## Hard rules

- **`dotfiles` is a submodule, not a flake input.** It is fetched via
  `inputs.self.submodules = true` and passed around as the `dotfiles`
  specialArg (built from `flakeRoot`). Do not reintroduce a `git+file:`
  input, absolute paths, or a separate input. Requires Nix >= 2.28 on
  every host.
- **The repo lives at `~/box/nix-config` on every machine**
  (`lib/dotfiles.nix`). Dotfile links use `mkOutOfStoreSymlink` to the
  live checkout - editing dotfiles takes effect without rebuilding.
- **The mc config is deliberately re-seeded on every activation**
  (`hm/programs/mc/`). Deterministic by design; do not "fix" it.
- **Do not resurrect removed hosts**: arilou (cold wallet, retired)
  and rh-krancher.
- **Do not bump `system.stateVersion` / `home.stateVersion`.**
- **Guard greps in activation scripts must not be prefixed with
  `run`** - the function prefix turns the intended filename into a grep
  argument (regression fixed in `fix(sudo)`).
- **Debian hosts use the native `targets.genericLinux.nixGL` module** -
  no `builtins.fetchurl` imports of PR-branch modules.
- **ASCII in markdown and comments: use `-` not `—`.** Avoid Unicode
  symbols in markdown files and code comments unless they are
  necessary, help human understanding, or significantly enrich
  semantics.
- **Align markdown tables with spaces.** Pad every cell so the `|`
  pipes line up across header, separator, and body rows when viewed
  raw.
- **Wrap markdown prose at 80 chars per line.** Tables are exempt, as
  are cases where wrapping breaks semantics or hurts readability.

## Before committing

- `nix flake check --no-build` must pass.
- Beware lazy evaluation: `flake check` does not force every option.
  If you touched a specific option, force-evaluate it, e.g.
  `nix eval '.#nixosConfigurations.vostok.config.systemd.tmpfiles.rules'`
  - this once caught a pure-eval bug that `flake check` missed.
- Format nix files with `just fmt` (alejandra via treefmt).

## Commit messages

Conventional prefixes, in order of typical use:

| Prefix     | Use                                    | Example                                                |
|------------|----------------------------------------|--------------------------------------------------------|
| `chore`    | housekeeping, removals, lockfile bumps | `chore(flake): remove rh-krancher homeConfiguration`   |
| `feat`     | new package, service, host             | `feat(vostok): add pkgs-unstable.claude-monitor`       |
| `fix`      | repairing something                    | `fix(sudo): guard secure_path appends (stray run arg)` |
| `refactor` | restructuring, no behavior change      | `refactor(flake): dotfiles via inputs.self.submodules` |
| `docs`     | README, comment-only changes           | `docs(flake): explain self.submodules`                 |
| `wip`      | mid-work snapshots, to be squashed     | `wip: rust toolchain experiments`                      |

- Scope is the host (`vostok`, `glider`, `qt-dl1`) or the area
  (`flake`, `hm`, `mc`, `sudo`, `nixos`).
- Subject <= 72 chars, imperative mood (`add`, `fix`, `remove`).
- Body only when the why is non-obvious; link issues when relevant.
- `wip:` replaces the old "Checkpoint" messages.

## Useful workflows

- `just update`, `just rebuild`, `just check`, `just fmt`, `just gc` -
  see the Justfile
- Submodules: `utils/maintenance/git-populate-submodules` (fresh
  clone), `git-update-submodules`, `git-reinit-submodules`,
  `git-clean`
- Debian hosts: switch with `just hm-switch-host <hostname>` and
  `just hm-switch-user <username>`
