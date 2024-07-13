{
  config,
  pkgs,
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
    nixgl.nixGLIntel
    # nixgl.nixVulkanIntel
  ];
}
