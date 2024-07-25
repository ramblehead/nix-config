{
  config,
  pkgs,
  lib,
}: {
  setupNix = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ln -fs  $VERBOSE_ARG \
      ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh \
      /etc/profile.d
  '';
}
