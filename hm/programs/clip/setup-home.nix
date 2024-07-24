{
  config,
  lib,
  flake-root,
  deduceRuntimePath,
}: let
  dotfiles = (deduceRuntimePath (flake-root + /dotfiles));
in {
  # see https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
  setupClip = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ln -fs $VERBOSE_ARG ${dotfiles} ${config.home.homeDirectory}
  '';
}
