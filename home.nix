{ config, pkgs, dotfiles, ... }:

{
  home.username = "rh";
  home.homeDirectory = "/home/rh";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  home.file.".inputrc".source = "${dotfiles}/.inputrc";

  programs.bash = {
    enable = true;
    shellAliases = {
      mc = "source ${pkgs.mc}/libexec/mc/mc-wrapper.sh";
    };
  };

  programs.alacritty.enable = true;
  home.file.".config/alacritty" = {
    source = "${dotfiles}/.config/alacritty";
    recursive = true;
  };

  programs.zellij.enable = true;
  home.file.".config/zellij" = {
    source = "${dotfiles}/.config/zellij";
    recursive = true;
  };

  programs.git.enable = true;
  home.file.".config/git" = {
    source = "${dotfiles}/.config/git";
    recursive = true;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Backup, Cloud Storage and NAS
    rclone
    restic
    # Terminals
    tmux
    # Misc
    fastfetch
    cowsay
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
