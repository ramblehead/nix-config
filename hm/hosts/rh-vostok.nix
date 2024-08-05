{
  config,
  pkgs,
  inputs,
  lib,
  flake-root,
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

    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    wl-clipboard
  ];
}
