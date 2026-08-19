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
    ANTHROPIC_AUTH_TOKEN = "ollama";

    ANTHROPIC_MODEL = "qwen3-coder:30b";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen3-coder:30b";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen3-coder:30b";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen3-coder:30b";
    CLAUDE_CODE_SUBAGENT_MODEL = "qwen3-coder:30b";

    CLAUDE_CODE_MAX_CONTEXT_TOKENS = "262144";
    CLAUDE_CODE_AUTO_COMPACT_WINDOW = "220000";

    CLAUDE_CODE_EFFORT_LEVEL = "max";
    # or
    # ANTHROPIC_MODEL = "qwen3-coder:30b[256k]";
    # or
    # CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT = "1";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.nix-profile/bin"
    "/nix/var/nix/profiles/per-user/root/profile/bin"
    "/nix/var/nix/profiles/default/sbin"
    "/nix/var/nix/profiles/default/bin"
  ];

  home.activation = let
    nix = (import (flakeRoot + /hm/programs/nix/setup-debian-home.nix)) {
      inherit pkgs;
      inherit lib;
    };
  in {
    setupQtOllamaUrl = lib.hm.dag.entryAfter ["writeBoundary"] ''
      file="$HOME/.profile"

      if [ ! -f "$file" ]; then
        run touch "$file"
      fi

      if ! grep -Fq "ANTHROPIC_BASE_URL" "$file"; then
        run sh -c '
          {
            printf "%s\n" "if [ -f \"$HOME/share/data/pit/ai-api/qt-ollama-url\" ]; then"
            printf "%s\n" "  export ANTHROPIC_BASE_URL=\"\$(cat \"$HOME/share/data/pit/ai-api/qt-ollama-url\")\""
            printf "%s\n" "fi"
            cat "$1"
          } > "$1.tmp" && mv "$1.tmp" "$1"
        ' _ "$file"
      fi
    '';

    inherit (nix) setupNix;
  };
}
