{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # Infosecurity
    # /b/{

    keepassxc

    # /b/}

    # Embedded systems
    # /b/{

    rpi-imager

    # /b/}
  ];
}
