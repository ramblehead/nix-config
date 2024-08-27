{
  # config,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "root";
  # home.homeDirectory = "/root";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # google-chrome
    zellij
    zoxide
    eza
    zip

    wget
    curl
    htop
    btop

    rpi-imager

    # Text editors and software development tools
    git
    gitui
    just
    neovim
    # micro
    inputs.helix.packages."${pkgs.system}".helix
    treefmt2
    hack-font
    ripgrep

    # Used via lsp-mode
    # semgrep

    # Backup, Cloud Storage and NAS
    rclone
    restic

    # Orthodox Commanders
    file # Used by mc
    mc
    ncdu
    dust
    # far2l

    # Text editors and software development tools
    just

    # Shells
    xonsh

    # Terminals
    tmux

    # Nix-related
    # /b/{

    nil
    alejandra

    # Generate Nix fetcher calls from repository URLs.
    # Use example:
    #   $ nurl https://github.com/nix-community/patsh v0.2.0 2>/dev/null
    #   fetchFromGitHub {
    #     owner = "nix-community";
    #     repo = "patsh";
    #     rev = "v0.2.0";
    #     hash = "sha256-7HXJspebluQeejKYmVA7sy/F3dtU1gc4eAbKiPexMMA=";
    #   }
    nurl

    # /b/}

    # Print and Scanned Documents
    # /b/{

    ghostscript

    # /b/}

    # Misc
    fastfetch
    cowsay

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
