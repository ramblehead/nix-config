{
  # config,
  pkgs,
  # inputs,
  # lib,
  # flake-root,
  ...
}: {
  home.packages = with pkgs; [
    # Terminal
    # /b/{

    alacritty

    # /b/}

    # Emacs
    # /b/{

    (emacs.override {
      withNativeCompilation = true;
      withPgtk = true;
      # withGTK3 = true;
    })
    emacsPackages.vterm
    emacsPackages.clang-format

    # /b/}

    # Rust
    # /b/{

    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    # /b/}

    # apt's build-essential
    # /b/{

    gcc
    gnumake
    autoconf
    automake
    libtool
    pkg-config
    cmake

    # /b/}

    # Cryptocurrency
    # /b/{

    bitcoin
    monero-cli
    monero-gui
    p2pool
    xmrig

    # /b/}

    # GUI
    # /b/{

    wl-clipboard
    gtk3

    # /b/}

    openssl
  ];
}
