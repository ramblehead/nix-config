{
  config,
  self,
  inputs,
  flakeRoot,
  ...
}: let
  # inherit (inputs) dotfiles;
  dotfilesLib = (import (flakeRoot + /lib/dotfiles.nix)) {
    inherit self;
    inherit config;
    inherit inputs;
  };
  inherit (dotfilesLib) deduceRuntimePath;
in {
  imports = [
    # Include the results of the hardware scan.
    ./rh.nix
    (flakeRoot + /hm/platforms/nixos.nix)
  ];

  home.file = {
    ".config/monitors.xml".source =
      config.lib.file.mkOutOfStoreSymlink (deduceRuntimePath
        (flakeRoot + "/dotfiles/hosts/vostok/.config/monitors.xml"));
  };
}
