{
  pkgs,
  lib,
}: {
  setupNix = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ln -fs  $VERBOSE_ARG \
      /nix/var/nix/profiles/default/etc/profile.d/hm-session-vars.sh \
      /etc/profile.d
  '';
}
