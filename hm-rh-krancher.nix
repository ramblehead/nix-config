{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nixGLIntel
    nixVulkanIntel
  ];
}
