{
  config,
  pkgs,
  lib,
  flake-root,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
  ];

  home.activation = let
    sudo = (import (flake-root + /hm/programs/sudo/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };

    mc = (import (flake-root + /hm/programs/mc/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };
  in {
    inherit (sudo) setupSudoers;
    inherit (mc) setupMcWrapper;
  };
}
