{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # Infosecurity
    # /b/{

    keepassxc

    # /b/}

    # Office Applications
    # /b/{

    libreoffice-fresh
    onlyoffice-bin_latest
    # softmaker-office - in-product purchase
    dia # Gnome Diagram drawing software

    # /b/}

    # Project Management
    # /b/{

    planner # Project management tool for the GNOME desktop
    treesheets # Free Form Data Organizer

    # /b/}

    # Images and Drawing
    # /b/{

    mypaint # painting app for artists
    pinta # Drawing/editing program modeled after Paint.NET
    gimp-with-plugins # The GNU Image Manipulation Program
    # libsForQt5.kolourpaint # Easy-to-use paint program from KDE
    # krita # Painting and animation application

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

    # Embedded systems
    # /b/{

    rpi-imager

    # /b/}
  ];
}
