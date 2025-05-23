{
  pkgs,
  pkgs-unstable,
  inputs,
}: {
  packages = with pkgs; [
    # Infosecurity
    # /b/{

    keepassxc

    # /b/}

    # Internet files exchange
    # /b/{

    deluge # Torrent client

    # /b/}

    # Project Management
    # /b/{

    planner # Project management tool for the GNOME desktop
    treesheets # Free Form Data Organizer
    obsidian # Knowledge base on top of a local folder of plain Markdown files

    # /b/}

    # Office Applications
    # /b/{

    # softmaker-office # In-product purchase
    # onlyoffice-bin_latest

    # /b/}

    # Images and Drawing
    # /b/{

    pinta # Drawing/editing program modeled after Paint.NET
    dia # Gnome Diagram drawing software
    # pkgs-unstable.yed # yEd - graph editor
    gimp-with-plugins # The GNU Image Manipulation Program
    # libsForQt5.kolourpaint # Easy-to-use paint program from KDE
    # mypaint # painting app for artists
    krita # Painting and animation application

    # /b/}

    # Fonts
    # /b/{

    hack-font
    vistafonts
    tamsyn

    nerdfonts
    # (nerdfonts.override {
    #   fonts = [
    #     # symbols icon only
    #     "NerdFontsSymbolsOnly"
    #     # Characters
    #     "FiraCode"
    #     "JetBrainsMono"
    #     "Iosevka"
    #   ];
    # })

    # /b/}
  ];
}
