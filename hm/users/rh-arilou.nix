{
  config,
  self,
  lib,
  inputs,
  flakeRoot,
  ...
}: let
  dotfilesLib = (import (flakeRoot + /lib/dotfiles.nix)) {
    inherit self;
    inherit config;
    inherit inputs;
  };
  inherit (dotfilesLib) deduceRuntimePath;
in {
  imports = [
    ./rh.nix
    (flakeRoot + /hm/platforms/nixos.nix)
  ];
}
