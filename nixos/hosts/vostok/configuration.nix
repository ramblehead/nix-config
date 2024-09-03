# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  # config,
  pkgs,
  inputs,
  flakeRoot,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./amdgpu-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enables support for SANE scanners
  hardware.sane.enable = true;

  networking.hostName = "vostok";

  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [pkgs.gnome.mutter];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      options = "numpad:microsoft";
      variant = "";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;
  };

  services.gnome = {
    gnome-remote-desktop.enable = true;
    games.enable = true;
  };

  programs.bash = {
    shellAliases = {
      mc = "source ${pkgs.mc}/libexec/mc/mc-wrapper.sh";
      vi = "nvim";
      vim = "nvim";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [pkgs.hplipWithPlugin];
  # services.printing.drivers = [ pkgs.hplipWithPlugin pkgs.hplip ];
  # services.printing.logLevel = "debug";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is
    # enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rh = {
    isNormalUser = true;
    description = "ramblehead";
    extraGroups = ["networkmanager" "wheel" "scanner" "lp"];
    # packages = with pkgs; [
    #   #  thunderbird
    # ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    utils-cli = (import (flakeRoot + /software/selections/utils-cli.nix)) {
      inherit pkgs;
      inherit inputs;
    };

    utils-gui = (import (flakeRoot + /software/selections/utils-gui.nix)) {
      inherit pkgs;
      inherit inputs;
    };

    crypto = (import (flakeRoot + /software/selections/cryptocurrency.nix)) {
      inherit pkgs;
      inherit inputs;
    };
  in
    utils-cli.packages
    ++ utils-gui.packages
    ++ crypto.packages
    ++ (with pkgs; [
      # Office Applications
      # /b/{

      libreoffice-fresh
      onlyoffice-bin_latest
      # softmaker-office # In-product purchase
      dia # Gnome Diagram drawing software

      # /b/}

      # Shells and terminals
      # /b/{

      alacritty

      # /b/}

      # Text Editors and Software Development Tools
      # /b/{

      (emacs.override {
        withNativeCompilation = true;
        withPgtk = true;
        # withGTK3 = true;
      })
      emacsPackages.vterm
      emacsPackages.clang-format

      # /b/}

      # Rust
      # /b/{

      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      rust-analyzer-nightly

      # /b/}

      # Equivalent of the apt-get build-dep
      # /b/{

      gcc
      gnumake
      pkg-config
      autoconf
      automake
      libtool
      cmake
      python3

      # /b/}

      # Infosecurity
      # /b/{

      openssl

      # /b/}

      # Embedded systems
      # /b/{

      rpi-imager

      # /b/}

      chromium
      telegram-desktop
      google-chrome

      pavucontrol # PulseAudio Volume Control
      gtk3
      wl-clipboard

      gnome.gnome-tweaks
      gnomeExtensions.arcmenu
      gnomeExtensions.date-menu-formatter
      gnomeExtensions.dash-to-panel
      gnomeExtensions.gtk4-desktop-icons-ng-ding
      gnomeExtensions.caffeine
      gnomeExtensions.clipboard-indicator
      # gnomeExtensions.vitals
      # gnomeExtensions.noannoyance-fork
      gnomeExtensions.steal-my-focus-window
      gnomeExtensions.system-monitor-next
      # Old tray icons, e.g. Telegram
      gnomeExtensions.appindicator
    ]);

  environment.variables.XCURSOR_THEME = "Adwaita";
  # environment.variables.PATH = lib.mkAfter "/etc/profiles/per-user/root/bin";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # system.activationScripts = {
  #   myScript.text = ''
  #     # DRY_RUN=''${DRY_RUN:-false}
  #     mkdir -p /etc/mycustomdir
  #   '';
  # };

  # List services that you want to enable:

  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    3389 # Default port used by Microsoft's RDP
    3390 # Alternative to 3389 for RDP
    22 # SSH Server
    18080 # Monero p2p port
    37889 # P2Pool p2p port
    37888 # P2Pool mini p2p port
  ];

  # networking.firewall.allowedUDPPorts = [ 3389 3390 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
