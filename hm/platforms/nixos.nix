{config, ...}: {
  programs.bash = {
    enable = true;
    sessionVariables = {
      PATH = "${config.home.homeDirectory}/.local/bin:$PATH";
      EDITOR = "em";
    };
  };
}
