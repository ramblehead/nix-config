{
  config,
  pkgs,
  self,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) dotfiles;
  dotfilesLib = (import ./lib/dotfiles.nix) {
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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

    ".config/zellij".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath ./dotfiles/.config/zellij);

    ".config/alacritty".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath ./dotfiles/.config/alacritty);

    ".local/bin/clip2output".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath ./dotfiles/.local/bin/clip2output);

    ".local/bin/file2clip".source =
      config.lib.file.mkOutOfStoreSymlink
      (deduceRuntimePath ./dotfiles/.local/bin/file2clip);
  };

  home.activation = {
    setupMc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      readonly MC_CONF="${config.home.homeDirectory}/.config/mc"
      mkdir -p "$MC_CONF"
      cp -n "${dotfiles}/.config/mc/ini" "$MC_CONF"
      chmod ug+w "$MC_CONF/ini"

      cp -n "${pkgs.mc}/etc/mc/mc.keymap" "$MC_CONF"
      chmod ug+w "$MC_CONF/mc.keymap"

      sed -i -E 's/^Store = ctrl-insert$/Store = ctrl-c; ctrl-insert/' \
                "$MC_CONF/mc.keymap"
      sed -i -E 's/^Paste = shift-insert$/Paste = ctrl-v; shift-insert/' \
                "$MC_CONF/mc.keymap"
      sed -i -E 's/^Cut = shift-delete$/Cut = ctrl-x; shift-delete/' \
                "$MC_CONF/mc.keymap"
      sed -i -E 's/^Undo = ctrl-u$/\0; ctrl-z/' \
                "$MC_CONF/mc.keymap"
      sed -i -E 's/^(WordLeft = ctrl-left)(; ctrl-z)$/\1/' \
                "$MC_CONF/mc.keymap"
      sed -i -E 's/^(WordRight = ctrl-right)(; ctrl-x)$/\1/' \
                "$MC_CONF/mc.keymap"

      cp -n "${pkgs.mc}/etc/mc/mc.menu" "$MC_CONF/menu"
      chmod ug+w "$MC_CONF/menu"

      sed -i -E 's/^( ?)(\s*)echo "\.\.\/\$tar\.tar\.lzo created\."$/&\
      \
      9\2Compress the current subdirectory (zip)\
      \1\2Pwd=`basename %d \/`\
      \1\2echo -n "Name of the compressed file (without extension) [$Pwd]: "\
      \1\2read zip\
      \1\2[ "$zip"x = x ] \&\& zip="$Pwd"\
      \1\2cd .. \&\& \\\
      \1\2zip -r "$Pwd" "$Pwd" \&\& \\\
      \1\2echo "..\/$zip.zip created."/' "$MC_CONF/menu"

      sed -i -E 's/^( ?)(\s*)open -s -- sh$/&\
      \
      !\Open mc in as root\
      \1\2cd "$HOME" \&\& alacritty --command sudo mc %d %D \&/' "$MC_CONF/menu"
    '';
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
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

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
