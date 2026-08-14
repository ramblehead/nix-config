{config, ...}: {
  home.sessionVariables = {
    EDITOR = "em";

    # claude-code DeepSeek configuration
    ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic";
    ANTHROPIC_MODEL = "deepseek-v4-pro[1m]";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "deepseek-v4-pro[1m]";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "deepseek-v4-pro[1m]";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "deepseek-v4-flash";
    CLAUDE_CODE_SUBAGENT_MODEL = "deepseek-v4-flash";
    CLAUDE_CODE_EFFORT_LEVEL = "max";
    CLAUDE_CODE_AUTO_COMPACT_WINDOW = "786432";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -f "$HOME/share/data/pit/ai-api/deepseek" ]; then
        export ANTHROPIC_AUTH_TOKEN="$(cat "$HOME/share/data/pit/ai-api/deepseek")"
      fi
    '';
    # sessionVariables = {
    #   PATH = "${config.home.homeDirectory}/.local/bin:$PATH";
    #   EDITOR = "em";
    # };
  };
}
