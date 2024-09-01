{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # Infosecurity
    # /b/{

    keepassxc

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
