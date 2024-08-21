{
  config,
  pkgs,
  # self,
  # inputs,
  ...
  # }: let
  #   inherit (inputs) dotfiles;
  #   dotfilesLib = (import ./lib/dotfiles.nix) {
  #     inherit self;
  #     inherit config;
  #     inherit inputs;
  #   };
  #   inherit (dotfilesLib) deduceRuntimePath;
  # in {
}: {
  imports = [
    ./rh.nix
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      mc = "source ${pkgs.mc}/libexec/mc/mc-wrapper.sh";
      vi = "nvim";
      vim = "nvim";
    };
  };

  home.sessionVariables = {
    PATH = "${config.home.homeDirectory}/.local/bin:$PATH";
    EDITOR = "em";
    MC_XDG_OPEN="xdg-open";
  };
}
