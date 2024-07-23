{
  pkgs,
  lib,
  config,
}: {
  setupNix = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ln -fs ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh \
      /etc/profile.d
  '';
}
