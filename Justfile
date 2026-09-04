# Inspirations:
# https://github.com/kamadorueda/alejandra for good Nix practices.
# https://github.com/juspay/nix-dev-home

# nix-store --verify --repair

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

update-input input:
  nix flake lock --update-input {{input}}

# sudo nixos-rebuild switch --flake .
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
# clean-hm:
#   home-manager expire-generations 7d
#   sudo home-manager expire-generations 7d

hm-news:
  home-manager news --flake "$PWD#$(hostname)"

# remove all generations older than 7 days
clean:
  # system profile
  sudo nix profile wipe-history \
    --profile /nix/var/nix/profiles/system  \
    --older-than 7d
  # user profile
  nix profile wipe-history --older-than 7d
  sudo nixos-rebuild boot

# remove all generations
clean-all:
  sudo nix profile wipe-history \
    --profile /nix/var/nix/profiles/system
  sudo nixos-rebuild boot
  # Remove auto GC-roots
  sudo rm -vf /nix/var/nix/gcroots/auto/*

# Garbage collect all unused nix store entries
gc:
  # sudo nix store gc --print-dead
  sudo nix store gc --debug

# Remove all reflog entries and prune unreachable objects
git-gc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

# Check nix flake
check:
  nix flake check

# Lint and format the nix files in this repo
fmt:
  # nix fmt
  treefmt --walk=filesystem

# Print surrent $PATH - one path par line
path:
  echo $PATH | sed -e 's/:/\n/g'

# Re-build system caches - font, icons etc.
kde-cache-rebuild:
  command -v kbuildsycoca5 >/dev/null 2>&1 && kbuildsycoca5 --noincremental
  fc-cache -f -v

# Initialise root (global) home-manager
hm-init-host:
  sudo -i nix run home-manager/release-26.05 -- switch --flake "$PWD#$(hostname)"

# Switch host (root - global) home-manager
hm-switch-host:
  sudo home-manager switch --flake "$PWD#$(hostname)"

# Switch user home-manager
hm-switch-user:
  home-manager switch --flake "$PWD"

# Run `hm-init-user` an `hm-switch-user`
hm-switch:
  @just hm-switch-host
  @just hm-switch-user
