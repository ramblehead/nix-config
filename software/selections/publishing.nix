{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # LaTex
    # /b/{

    texliveFull # Popular LaTeX system for Linux
    ipe # Editor for drawing figures with LaTeX integration

    # /b/}
  ];
}
