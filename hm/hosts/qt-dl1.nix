{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
  ];

  home.activation = let
    sudo = (import ./hm/programs/sudo/setup-debian.nix) {
      inherit pkgs;
      inherit lib;
    };

    mc = (import ./hm/programs/mc/setup-debian.nix) {
      inherit pkgs;
      inherit lib;
    };
  in {
    inherit (sudo) setupSudoers;
    inherit (mc) setupMcWrapper;
  };
}
