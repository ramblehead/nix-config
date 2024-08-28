{
  config,
  pkgs,
  ...
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
    sessionVariables = {
      PATH = "${config.home.homeDirectory}/.local/bin:$PATH";
      EDITOR = "em";
    };
  };

  # home.sessionVariables = {
  #   MC_XDG_OPEN = "xdg-open";
  #   RUST_SRC_PATH = "${pkgs.fenix.complete.rust-src}/lib/rustlib/src/rust/library";
  # };
}
