{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # System information, monitors, control and benchmarking
    # /b/{

    fastfetch # Fetching and prettily-displaying system information
    htop # Better top
    btop # Better htop
    systemctl-tui # TUI for dystemd

    # /b/}

    # Files management and backup
    # /b/{

    mc
    # far2l # has a potential to takeover mc when more developed/stable
    zip
    unzip
    rar
    p7zip
    file # Used by mc
    ncdu # du with TUI interface
    dust # a better ncdu
    rclone # command-line program to manage files on cloud storage
    restic # backup program
    ripgrep # Fast version of grep
    # zoxide # cd command replacement with intelligent auto-completion
    eza # ls command replacement with tree output
    fd # fast and user-friendly alternative to find

    # /b/}

    # Shells and terminals
    # /b/{

    tmux # Terminal Multiplexer
    # zellij # New user-friendly terminal multiplexer
    # xonsh # Python-based full-featured and cross-platform shell

    # /b/}

    # Text Editors and Software Development Tools
    # /b/{

    git
    gitui
    just
    treefmt
    neovim
    # micro
    # inputs.helix.packages."${pkgs.system}".helix
    # semgrep # can be used used via lsp-mode
    shellcheck # shell script static analysis tool

    # /b/}

    # Spell Checkers
    # /b/{

    hunspell
    hunspellDicts.ru-ru
    # hunspellDicts.en-us
    hunspellDicts.en-us-large
    # hunspellDicts.en-gb-ise
    hunspellDicts.en-gb-large

    # /b/}

    # Network
    # /b/{

    wget
    curl
    sshfs

    # /b/}

    # Nix-related
    # /b/{

    nil # Yet another language server for Nix
    alejandra # The Uncompromising Nix Code Formatter

    # Generate Nix fetcher calls from repository URLs
    # Use example:
    #   $ nurl https://github.com/nix-community/patsh v0.2.0 2>/dev/null
    #   fetchFromGitHub {
    #     owner = "nix-community";
    #     repo = "patsh";
    #     rev = "v0.2.0";
    #     hash = "sha256-7HXJspebluQeejKYmVA7sy/F3dtU1gc4eAbKiPexMMA=";
    #   }
    nurl

    # /b/}

    # Misc
    # /b/{

    cowsay

    # /b/}

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number
    # # of fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
