{
  # config,
  pkgs,
  # inputs,
  # lib,
  # flake-root,
  ...
}: {
  home.packages = with pkgs; [
    # Shells and terminals
    # /b/{

    alacritty

    # /b/}

    # Text Editors and Software Development Tools
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
    pkg-config
    autoconf
    automake
    libtool
    cmake
    python3

    # /b/}

    # Cryptocurrencies
    # /b/{

    bitcoin
    monero-cli
    monero-gui
    p2pool
    xmrig

    # /b/}

    # Infosecurity
    # /b/{

    openssl

    # /b/}

    # GUI
    # /b/{

    wl-clipboard
    gtk3

    # /b/}
  ];
}
