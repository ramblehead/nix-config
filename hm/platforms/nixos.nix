{config, ...}: {
  home.sessionVariables = {
    EDITOR = "em";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.bash = {
    enable = true;
  };
}
