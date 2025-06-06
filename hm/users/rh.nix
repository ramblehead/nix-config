{
  config,
  pkgs,
  self,
  lib,
  inputs,
  flakeRoot,
  ...
}: let
  dotfilesLib = (import (flakeRoot + /lib/dotfiles.nix)) {
    inherit self;
    inherit config;
    inherit inputs;
  };
  inherit (dotfilesLib) deduceRuntimePath;
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rh";
  home.homeDirectory = "/home/rh";

  # link the configuration file in current directory to the specified location
  # in home directory home.file.".config/i3/wallpaper.jpg".source =
  # ./wallpaper.jpg;

  # Control individual project environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number
    # # of fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc'
    # # a symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".inputrc".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.inputrc));

    ".hunspell_personal".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.hunspell_personal));

    ".config/direnv/direnv.toml".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.config/direnv/direnv.toml));

    ".config/git".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.config/git));

    ".config/emacs".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.config/emacs));

    ".local/bin/em".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.local/bin/em));

    ".config/zellij".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.config/zellij));

    ".config/alacritty".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.config/alacritty));

    ".local/bin/zj".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.local/bin/zj));

    ".local/bin/tmx".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.local/bin/tmx));

    ".tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.tmux.conf));

    ".local/bin/clip2output".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.local/bin/clip2output));

    ".local/bin/file2clip".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath (flakeRoot + /dotfiles/.local/bin/file2clip));
  };

  home.activation = let
    mc = (import (flakeRoot + /hm/programs/mc/setup-home.nix)) {
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
