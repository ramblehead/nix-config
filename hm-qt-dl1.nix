{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
  ];

  home.activation = let
    mc = (import ./hm/programs/mc/setup-debian.nix) {
      inherit pkgs;
      inherit lib;
    };
  in {
    setupSudoers = lib.hm.dag.entryAfter ["writeBoundary"] ''
      SUDS=/etc/sudoers
      if ! grep '^.*secure_path=.*/nix/var/nix/profiles/default/s\?bin.*$' \
         $SUDS &>/dev/null
      then
        readonly BIN=/nix/var/nix/profiles/default/bin
        readonly SBIN=/nix/var/nix/profiles/default/sbin
        sed -E 's|^(.*secure_path=".*)(")$|\1:'$SBIN:$BIN'\2|' -i $SUDS
      fi
    '';

    inherit (mc) setupMcWrapper;
  };
}
