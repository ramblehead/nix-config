{
  config,
  pkgs,
  # self,
  lib,
  inputs,
  flakeRoot,
  ...
}: {
  home.username = "root";
  home.homeDirectory = "/root";

  # home.packages = let
  #   utils-cli = (import (flakeRoot + /software/selections/utils-cli.nix)) {
  #     inherit pkgs;
  #     inherit inputs;
  #   };
  # in
  #   lib.mkIf (! isNixOS) utils-cli.packages;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.activation = let
    mc = (import (flakeRoot + /hm/programs/mc/setup-nw-home.nix)) {
      inherit config;
      inherit pkgs;
      inherit lib;
      inherit inputs;
    };
  in {
    inherit (mc) setupMc;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rh/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {};

  # This value determines whether home Manager should use the XDG base
  # directory specification for placing configuration files and other
  # user-specific data files.
  #
  # When set to true, home Manager will place configuration files in
  # ~/.config, data files in ~/.local/share, and cache files in
  # ~/.cache according to the XDG base directory specification.
  home.preferXdgDirectories = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
