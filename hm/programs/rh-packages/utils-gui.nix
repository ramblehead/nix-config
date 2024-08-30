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
    jetbrains-mono
    fira-code
    iosevka

    # /b/}

    # Embedded systems
    # /b/{

    rpi-imager

    # /b/}
  ];
}
