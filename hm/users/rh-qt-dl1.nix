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
    # Claude Code → local Ollama
    ANTHROPIC_AUTH_TOKEN = "ollama";
    # ANTHROPIC_API_KEY = ""; # empty so Claude Code doesn't try Anthropic auth
    ANTHROPIC_BASE_URL = "http://qkd-gpu-1.crl.toshiba.co.uk:5000/";

    # Default model (change to whatever you have pulled)
    ANTHROPIC_MODEL = "qwen3-coder";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen3-coder";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen3-coder";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen3-coder"; # or a smaller/faster model
    CLAUDE_CODE_SUBAGENT_MODEL = "qwen3-coder";
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
    inherit (nix) setupNix;
  };
}
