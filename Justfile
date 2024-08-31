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

update-input input:
  nix flake lock --update-input {{input}}

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
  sudo nix profile wipe-history \
    --profile /nix/var/nix/profiles/system  \
    --older-than 7d
  sudo nixos-rebuild boot

# remove all generations
clean-all:
  sudo nix profile wipe-history \
    --profile /nix/var/nix/profiles/system
  sudo nixos-rebuild boot
  # Remove auto GC-roots
  sudo rm -vf /nix/var/nix/gcroots/auto/*

gc:
  # Garbage collect all unused nix store entries
  sudo nix store gc --debug
  nix store gc --debug
  sudo nix-collect-garbage --delete-old
  nix-collect-garbage --delete-old

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

# Build font information cache files
cache-fonts:
  fc-cache -f -v 

# Initialise root (global) home-manager
hm-init-host *hostname:
  sudo -i nix run home-manager/release-24.05 -- init --switch ${PWD}
  @just hm-root-switch {{hostname}}

# Switch host (root - global) home-manager
hm-switch-host *hostname:
  if [ -z "{{hostname}}" ]; then \
    sudo -i home-manager switch --flake "$PWD#$(hostname)"; \
  else \
    sudo -i home-manager switch --flake "$PWD#{{hostname}}"; \
  fi

# Initialise user home-manager
hm-init-user *username:
  home-manager init --switch ${PWD}
  @just hm-switch {{username}}

# Switch user home-manager
hm-switch-user *username:
  UN={{username}}; home-manager switch --flake "$PWD${UN:+#}$UN"
