{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # LaTex
    # /b/{

    texliveFull # Popular LaTeX system for Linux

    # /b/}

    # Graphics
    # /b/{

    ipe # Editor for drawing figures with LaTeX integration
    plantuml
    ditaa
    graphviz
    kgraphviewer

    # /b/}

    # Print and Scanned Documents
    # /b/{

    ghostscript

    # /b/}
  ];
}
