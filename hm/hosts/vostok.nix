{
  # config,
  pkgs,
  # inputs,
  # lib,
  # flake-root,
  ...
}: {
  home.packages = with pkgs; [
    alacritty

    (emacs.override {
      withNativeCompilation = true;
      withPgtk = true;
      # withGTK3 = true;
    })
    emacsPackages.vterm
    emacsPackages.clang-format

    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    bitcoin
    monero-cli
    monero-gui

    wl-clipboard
  ];
}
