{
  config,
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
  imports = [
    ./rh.nix
    (flakeRoot + /hm/platforms/nixos.nix)
  ];

  home.sessionVariables = {
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

  programs.bash = {
    initExtra = ''
      if [ -f "$HOME/share/data/pit/ai-api/deepseek" ]; then
        export ANTHROPIC_AUTH_TOKEN="$(cat "$HOME/share/data/pit/ai-api/deepseek")"
      fi
    '';
  };

  home.activation = {
    backupExistingMonitorsXml = lib.hm.dag.entryBefore ["linkGeneration"] ''
      if [ -e "${config.home.homeDirectory}/.config/monitors.xml" ]; then
        run mv -f "${config.home.homeDirectory}/.config/monitors.xml" \
           "${config.home.homeDirectory}/.config/monitors.xml~"
      fi
    '';
  };

  home.file = {
    ".config/monitors.xml".source =
      config.lib.file.mkOutOfStoreSymlink (deduceRuntimePath
        (flakeRoot + "/dotfiles/hosts/vostok/.config/monitors.xml"));
  };
}
