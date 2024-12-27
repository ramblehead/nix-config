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

  home.activation = {
    backupExistingMonitorsXml = lib.hm.dag.entryBefore ["linkGeneration"] ''
      if [ -e "${config.home.homeDirectory}/.config/monitors.xml" ]; then
        run mv -f "${config.home.homeDirectory}/.config/monitors.xml" \
           "${config.home.homeDirectory}/.config/monitors.xml~"
      fi
    '';
  };

  home.file = {
    ".config/monitors.xml".source =
      config.lib.file.mkOutOfStoreSymlink (deduceRuntimePath
        (flakeRoot + "/dotfiles/hosts/vostok/.config/monitors.xml"));
  };
}
