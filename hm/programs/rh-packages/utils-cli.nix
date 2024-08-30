{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # System information, monitors and benchmarking
    # /b/{

    fastfetch # Fetching and prettily-displaying system information
    htop # Better top
    btop # Better htop

    # /b/}

    # Files management and backup
    # /b/{

    mc
    # far2l # has a potential to takeover mc when more developed/stable
    zip
    file # Used by mc
    ncdu # du with TUI interface
    dust # a better ncdu
    rclone # command-line program to manage files on cloud storage
    restic # backup program

    # /b/}

    # Shells and terminals
    # /b/{

    tmux # Terminal Multiplexer
    zellij # New user-friendly terminal multiplexer
    xonsh # Python-based full-featured and cross-platform shell
    # zoxide # cd command replacement with intelligent auto-completion
    eza # ls command replacement with tree output

    # /b/}

    # Text Editors and Software Development Tools
    # /b/{

    git
    gitui
    just
    neovim
    # micro
    inputs.helix.packages."${pkgs.system}".helix
    treefmt2
    hack-font
    jetbrains-mono
    fira-code
    ripgrep
    # semgrep # can be used used via lsp-mode

    # /b/}

    # Network
    # /b/{

    wget
    curl

    # /b/}

    # Nix-related
    # /b/{

    nil # Yet another language server for Nix
    alejandra # The Uncompromising Nix Code Formatter

    # Generate Nix fetcher calls from repository URLs.
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

    # Print and Scanned Documents
    # /b/{

    ghostscript

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
