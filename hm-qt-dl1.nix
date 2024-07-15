{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    mc
  ];

  home.activation = {
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

    setupMc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      SUDS=/etc/bash.bashrc
      if ! grep 'alias.*mc=' $SUDS \
         &>/dev/null
      then
        # if [ "$(tail -c 1 $SUDS | xxd -p)" != "0a" ]; then
        # if [ "$(tail -c 1 $SUDS | wc -l)" -ne 1 ]; then
        if (( "$(tail -c 1 $SUDS | wc -l)" < 1 )); then
          echo >> $SUDS
        fi

        echo -e "\nalias mc='. ${pkgs.mc}/libexec/mc/mc-wrapper.sh'" >> $SUDS
      fi
    '';
  };
}
