# Inspirations:
# https://github.com/kamadorueda/alejandra for good Nix practices.
# https://github.com/juspay/nix-dev-home

# Default command when 'just' is run without arguments
default:
  @just --list

# Print nix flake inputs and outputs
io:
  nix flake metadata
  nix flake show

# Update nix flake
update:
  nix flake update

update-package pkg:
  nix flake update {{pkg}}

rebuild:
  sudo nixos-rebuild switch --flake .

# List all generations of the system profile
history:
  nix profile history --profile /nix/var/nix/profiles/system

list-packages:
  nix profile list --profile /nix/var/nix/profiles/system

metadata:
  nix flake metadata .

# Open a nix shell with the flake
repl:
  nix repl -f flake:nixpkgs

# Manually enter dev shell
dev:
  nix develop

# remove all generations older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
  sudo nixos-rebuild boot
  # Remove auto GC-roots
  sudo rm -f /nix/var/nix/gcroots/auto/*

gc:
  # Garbage collect all unused nix store entries
  sudo nix store gc --debug
  nix store gc --debug
  sudo nix-collect-garbage --delete-old
  nix-collect-garbage --delete-old

# Remove all reflog entries and prune unreachable objects
gitgc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

# Check nix flake
check:
  nix flake check

# Lint and format the nix files in this repo
lint:
  nix fmt

# Print surrent $PATH - one path par line
path:
  echo $PATH | sed -e 's/:/\n/g'

# Initialise global (root) home-manager for host
home-manager-global-init host:
  sudo -i nix run home-manager/release-24.05 -- init --switch ${PWD}
  sudo -i home-manager switch --flake ${PWD}#{{host}}

home-manager-global-init host-user:
  home-manager init --switch ${PWD}
  home-manager switch --flake ${PWD}#{{host-user}}
