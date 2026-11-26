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
    ANTHROPIC_AUTH_TOKEN = "$(cat \"${config.home.homeDirectory}/share/data/pit/ai-api/deepseek\" 2>/dev/null)";
    ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic";
    ANTHROPIC_MODEL = "deepseek-v4-pro[1m]";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "deepseek-v4-pro[1m]";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "deepseek-flash[1m]";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "deepseek-flash";
    CLAUDE_CODE_SUBAGENT_MODEL = "deepseek-v4-pro[1m]";

    CLAUDE_CODE_AUTO_COMPACT_WINDOW = "786432";

    CLAUDE_CODE_EFFORT_LEVEL = "max";
  };

  # OpenSSH agent for CLI/SSH sessions, so key passphrases are asked
  # once per session instead of on every connection. GUI sessions
  # already use the gcr-ssh-agent (services.gnome.gcr-ssh-agent), and
  # nixpkgs asserts programs.ssh.startAgent against it - hence the
  # home-manager agent here instead of the NixOS-level option.
  services.ssh-agent.enable = true;

  # The ssh-agent module only exports SSH_AUTH_SOCK in ~/.profile,
  # which non-login shells (e.g. terminal tabs) never source. Repeat
  # the export in the home-manager-managed ~/.bashrc; the guard also
  # preserves agents forwarded via `ssh -A`.
  programs.bash.initExtra = ''
    if [ -z "$SSH_AUTH_SOCK" -o -z "$SSH_CONNECTION" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
    fi
  '';

  # Non-interactive remote commands (e.g. `waypipe ssh vostok.lan
  # emacs`) source neither .profile nor .bashrc, so ssh clients
  # spawned there never see SSH_AUTH_SOCK and re-prompt for
  # passphrases. Point the ssh client at the agent socket directly,
  # unless an agent was forwarded. ~/.ssh/config is fully managed
  # here; its former hand-edited content is below.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraOptionOverrides = {
      AddKeysToAgent = "yes";
      IdentityFile = [
        "~/.ssh/ramblehead-github"
        "~/.ssh/ramblehead-level-2_ed25519"
        "~/.ssh/art-portal_ed25519"
      ];
    };
    settings.default-agent = {
      header = ''Match exec "test -z \"$SSH_AUTH_SOCK\""'';
      IdentityAgent = "\${XDG_RUNTIME_DIR}/ssh-agent";
    };
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
