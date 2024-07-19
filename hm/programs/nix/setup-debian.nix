{
  pkgs,
  lib,
}: {
  setupNix = lib.hm.dag.entryAfter ["writeBoundary"] ''
    BARC=/etc/bash.bashrc
    if ! grep "\\. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'" $BARC \
       &>/dev/null
    then
      if (( "$(tail -c 1 $BARC | wc -l)" < 1 )); then
        echo >> $BARC
      fi

      cat <<-EOF >> $BARC
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      EOF
    fi
  '';
}
