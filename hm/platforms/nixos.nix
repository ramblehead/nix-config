{config, ...}: {
  home.sessionVariables = {
    EDITOR = "em";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.bash = {
    enable = true;
    # sessionVariables = {
    #   # PATH = "${config.home.homeDirectory}/.local/bin:$PATH";
    #   PATH = "${config.home.homeDirectory}${PATH:+:}$PATH";
    #   EDITOR = "em";
    # };
  };
}
