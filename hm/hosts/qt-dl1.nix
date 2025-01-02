{
  config,
  pkgs,
  inputs,
  lib,
  flakeRoot,
  ...
}: {
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  #nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = ["mesa"];

  home.packages = let
    utils-cli = (import (flakeRoot + /software/selections/utils-cli.nix)) {
      inherit pkgs;
      inherit inputs;
    };

    utils-gui = (import (flakeRoot + /software/selections/utils-gui.nix)) {
      inherit pkgs;
      inherit inputs;
    };

    database = (import (flakeRoot + /software/selections/database.nix)) {
      inherit pkgs;
      inherit inputs;
    };
  in
    utils-cli.packages
    ++ utils-gui.packages
    ++ database.packages
    ++ (with pkgs; [
      # (config.lib.nixGL.wrap wayland)
      # (config.lib.nixGL.wrap gnome.gdm)
      # (config.lib.nixGL.wrap gnome.gnome-shell)

      # Install via cargo to avoid glibc issues
      (config.lib.nixGL.wrap alacritty)

      (emacs.override {
        withNativeCompilation = true;
        # withPgtk = true;
        withGTK3 = true;
      })
      emacsPackages.vterm

      # Native KDE Dolphin in current Debian 12 is leaking memory
      # and hungs. The following installation seems to fix it.
      libsForQt5.dolphin

      # (fenix.complete.withComponents [
      #   "cargo"
      #   "clippy"
      #   "rust-src"
      #   "rustc"
      #   "rustfmt"
      # ])
      # rust-analyzer-nightly

      wl-clipboard
    ]);

  home.activation = let
    nix = (import (flakeRoot + /hm/programs/nix/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };

    sudo = (import (flakeRoot + /hm/programs/sudo/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };

    mc = (import (flakeRoot + /hm/programs/mc/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };
  in {
    inherit (nix) setupNix;
    inherit (sudo) setupSudoers;
    inherit (mc) setupMcWrapper;
  };
}
