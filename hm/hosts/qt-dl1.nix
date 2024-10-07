{
  config,
  pkgs,
  inputs,
  lib,
  flakeRoot,
  ...
}: let
  inherit (inputs.nixgl.packages."${pkgs.system}") nixGLIntel;
in {
  imports = [
    # todo: remove when https://github.com/nix-community/home-manager/pull/5355 gets merged:
    # see https://github.com/Smona/home-manager/blob/nixgl-compat/modules/misc/nixgl.nix
    #     https://github.com/giggio/dotfiles/blob/main/home-manager/home.nix
    #     https://github.com/giggio/dotfiles/blob/main/home-manager/flake.nix
    #     https://github.com/nix-community/home-manager/issues/3968
    #     https://github.com/nix-community/home-manager/pull/5355
    # Provides nixGLwrap function
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "0g5yk54766vrmxz26l3j9qnkjifjis3z2izgpsfnczhw243dmxz9";
    })
  ];

  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";

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
      # nixgl.nixGLIntel
      # nixgl.auto.nixGLDefault
      # nixgl.nixVulkanIntel
      nixGLIntel

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
