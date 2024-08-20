{
  config,
  pkgs,
  inputs,
  lib,
  flake-root,
  ...
}: let
  inherit (pkgs) system;
  inherit (inputs.nixgl.packages."${system}") nixGLIntel;
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

  home.packages = with pkgs; [
    # nixgl.nixGLIntel
    # nixgl.auto.nixGLDefault
    # nixgl.nixVulkanIntel
    nixGLIntel

    # (config.lib.nixGL.wrap wayland)
    # (config.lib.nixGL.wrap gnome.gdm)
    # (config.lib.nixGL.wrap gnome.gnome-shell)

    (config.lib.nixGL.wrap alacritty)

    (emacs.override {
      withNativeCompilation = true;
      # withPgtk = true;
      withGTK3 = true;
    })
    emacsPackages.vterm

    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    bitcoin

    xsel
  ];

  # xsession.enable = true;
  # xsession.windowManager.command = "gdm";

  home.activation = let
    nix = (import (flake-root + /hm/programs/nix/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };

    sudo = (import (flake-root + /hm/programs/sudo/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };

    mc = (import (flake-root + /hm/programs/mc/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };
  in {
    inherit (nix) setupNix;
    inherit (sudo) setupSudoers;
    inherit (mc) setupMcWrapper;
  };
}
