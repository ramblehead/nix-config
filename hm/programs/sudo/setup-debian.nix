{
  pkgs,
  lib,
}: {
  setupSudoers = lib.hm.dag.entryAfter ["writeBoundary"] ''
    readonly SUDS=/etc/sudoers
    if ! grep '^.*secure_path=.*/nix/var/nix/profiles/default/s\?bin.*$' \
       run $SUDS &>/dev/null
    then
      readonly BIN=/nix/var/nix/profiles/default/bin
      readonly SBIN=/nix/var/nix/profiles/default/sbin
      run sed -E 's|^(.*secure_path="/usr/local/sbin:/usr/local/bin)(.*")$|\
      \1:'$SBIN:$BIN'\2|' -i $SUDS
    fi
  '';
}
