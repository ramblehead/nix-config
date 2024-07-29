{
  description = "Alacritty flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in rec {
    packages.${system}.alacritty = pkgs.stdenv.mkDerivation {
      name = "alacritty";
      src = pkgs.fetchFromGitHub {
        owner = "alacritty";
        repo = "alacritty";
        rev = "v0.13.2";
        hash = "sha256-MrlzAZWLgfwIoTdxY+fjWbrv7tygAjnxXebiEgwOM9A=";
      };
      buildInputs = [pkgs.cargo pkgs.rustc];
      buildPhase = ''
        cargo build --release
      '';
      installPhase = ''
        install -D target/release/alacritty $out/bin/alacritty
      '';
    };

    devShell.${system} = pkgs.mkShell {
      # buildInputs = [pkgs.cargo pkgs.rustc];
      inherit (packages.${system}.alacritty) buildInputs;
      shellHook = ''
        echo "Entering Alacritty build environment..."
      '';
    };
  };
}
