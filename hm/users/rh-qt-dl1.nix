{
  config,
  pkgs,
  lib,
  flakeRoot,
  ...
}: {
  imports = [
    ./rh.nix
  ];

  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "$(cat \"${config.home.homeDirectory}/share/data/pit/ai-api/qt-ollama-url\" 2>/dev/null)";
    ANTHROPIC_AUTH_TOKEN = "ollama";

    ANTHROPIC_MODEL = "qwen3-coder:30b";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen3.6:35b";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "muse-glimmer:30b";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen3.6:27b";
    CLAUDE_CODE_SUBAGENT_MODEL = "qwen3.6:35b";

    CLAUDE_CODE_MAX_CONTEXT_TOKENS = "262144";
    CLAUDE_CODE_AUTO_COMPACT_WINDOW = "220000";

    CLAUDE_CODE_EFFORT_LEVEL = "max";
    # or
    # ANTHROPIC_MODEL = "qwen3-coder:30b[256k]";
    # or
    # CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT = "1";
  };

  # home.sessionPath = [
  #   "$HOME/.nix-profile/bin"
  # ];

  home.activation = let
    nix = (import (flakeRoot + /hm/programs/nix/setup-debian-home.nix)) {
      inherit pkgs;
      inherit lib;
    };
  in {
    inherit (nix) setupNix;
  };
}
