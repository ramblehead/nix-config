{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  flakeRoot,
  ...
}: {
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  #nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = ["mesa"];

  home.packages = let
    utils-cli = (import (flakeRoot + /software/selections/utils-cli.nix)) {
      inherit pkgs;
      inherit inputs;
    };

    utils-gui = (import (flakeRoot + /software/selections/utils-gui.nix)) {
      inherit pkgs;
      inherit pkgs-unstable;
      inherit inputs;
    };

    database = (import (flakeRoot + /software/selections/database.nix)) {
      inherit pkgs;
      inherit inputs;
    };

    llm = (import (flakeRoot + /software/selections/llm.nix)) {
      inherit pkgs;
      inherit inputs;
    };
  in
    utils-cli.packages
    ++ utils-gui.packages
    ++ database.packages
    ++ llm.packages
    ++ (with pkgs; [
      (config.lib.nixGL.wrap alacritty)

      (emacs.override {
        withNativeCompilation = true;
        # withPgtk = true;
        withGTK3 = true;
      })

      emacsPackages.vterm
      pkgs-unstable.aider-chat

      # Native KDE Dolphin in current Debian 12 is leaking memory
      # and hungs. The following installation seems to fix it.
      libsForQt5.dolphin

      # (fenix.stable.withComponents [
      (fenix.complete.withComponents [
        "rustc"
        "cargo"
        "rust-src"
        "clippy"
        "rustfmt"
        "rust-docs"
        "rust-analysis"
        "rust-analyzer"
      ])

      cargo-run-bin

      # (rust-bin.stable.latest.default.override {
      #   extensions = [
      #     # for x86_64-unknown-linux-gnu
      #     "rust"
      #     "rust-docs"
      #     "rust-src"
      #     "clippy"
      #     "cargo"
      #     "rust-analysis"
      #     "rust-analyzer"
      #     "rust-std"
      #     "rustc-docs"
      #     "rustfmt"
      #     # "clippy-preview"
      #     # "llvm-bitcode-linker"
      #     # "llvm-bitcode-linker-preview"
      #     # "llvm-tools"
      #     # "llvm-tools-preview"
      #     # "reproducible-artifacts"
      #     # "rls"
      #     # "rls-preview"
      #     # "rust-analyzer-preview"
      #     # "rustc-dev"
      #     # "rustfmt-preview"
      #   ];
      #   # targets = [
      #   #   "x86_64-unknown-linux-gnu" # Standard 64-bit Linux.
      #   #   "x86_64-apple-darwin" # 64-bit macOS.
      #   #   "x86_64-pc-windows-gnu" # 64-bit Windows with GNU toolchain.
      #   #   "wasm32-unknown-unknown" # WebAssembly without any OS.
      #   #   "aarch64-unknown-linux-gnu" # 64-bit ARM Linux.
      #   #   "i686-unknown-linux-gnu" # 32-bit Linux.
      #   #   "armv7-unknown-linux-gnueabihf" # 32-bit ARM Linux with hard float.
      #   # ];
      # })

      # rust-analyzer-nightly

      wl-clipboard
    ]);

  home.activation = let
    nix = (import (flakeRoot + /hm/programs/nix/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };

    sudo = (import (flakeRoot + /hm/programs/sudo/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };

    mc = (import (flakeRoot + /hm/programs/mc/setup-debian.nix)) {
      inherit pkgs;
      inherit lib;
    };
  in {
    inherit (nix) setupNix;
    inherit (sudo) setupSudoers;
    inherit (mc) setupMcWrapper;
  };
}
