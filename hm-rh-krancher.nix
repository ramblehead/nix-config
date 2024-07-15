{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # todo: remove when https://github.com/nix-community/home-manager/pull/5355 gets merged:
    # see https://github.com/giggio/dotfiles/blob/main/home-manager/home.nix
    #     https://github.com/giggio/dotfiles/blob/main/home-manager/flake.nix
    #     https://github.com/nix-community/home-manager/issues/3968
    #     https://github.com/nix-community/home-manager/pull/5355
    # Provides nixGLwrap function
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "0g5yk54766vrmxz26l3j9qnkjifjis3z2izgpsfnczhw243dmxz9";
    })
  ];

  nixGL.prefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";

  home.packages = with pkgs; [
    # nixgl.nixGLIntel
    # nixgl.auto.nixGLDefault
    # nixgl.nixVulkanIntel
    nixgl.nixGLIntel

    (config.lib.nixGL.wrap alacritty)

    xsel
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
