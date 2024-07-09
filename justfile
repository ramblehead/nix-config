# see https://github.com/kamadorueda/alejandra for good Nix practices.

# Default command when 'just' is run without arguments
default:
  @just --list

# Print nix flake inputs and outputs
io:
  nix flake metadata
  nix flake show

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

check:
  nix flake check

# format the nix files in this repo
fmt:
  nix fmt

path:
  echo $PATH | sed -e 's/:/\n/g'
