# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  # config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-df0c7e18-d73c-4c95-b37f-28a23c4b3fcc".device = "/dev/disk/by-uuid/df0c7e18-d73c-4c95-b37f-28a23c4b3fcc";

  networking.hostName = "arilou";

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
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    displayManager.gdm = {
      # Enable the GNOME Desktop Environment.
      enable = true;
      wayland = true;
      autoSuspend = false;
    };

    desktopManager.gnome = {
      # Enable the GNOME Desktop Environment.
      enable = true;
      extraGSettingsOverridePackages = [
        pkgs.gnome.gnome-desktop
        pkgs.mutter
      ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']

        # Configure window titlebar buttons
        [org.gnome.desktop.wm.preferences]
        button-layout='appmenu:minimize,maximize,close'
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

  programs.bash = {
    shellAliases = {
      mc = "source ${pkgs.mc}/libexec/mc/mc-wrapper.sh";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rh = {
    isNormalUser = true;
    description = "ramblehead";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System information, monitors and benchmarking
    # /b/{

    fastfetch # Fetching and prettily-displaying system information
    htop # Better top
    btop # Better htop

    # /b/}

    # Files management and backup
    # /b/{

    raider # Permanently delete your files (also named File Shredder)
    mc
    zip
    unzip
    rar
    file # Used by mc
    ncdu # du with TUI interface
    dust # a better ncdu
    ripgrep # Fast version of grep
    fd # fast and user-friendly alternative to find

    # /b/}

    # Text Editors and Software Development Tools
    # /b/{

    git
    just
    treefmt2
    shellcheck # shell script static analysis tool

    (emacs.override {
      withNativeCompilation = true;
      withPgtk = true;
      # withGTK3 = true;
    })

    emacsPackages.vterm
    emacsPackages.clang-format

    hack-font

    # /b/}

    # Spell Checkers
    # /b/{

    hunspell
    hunspellDicts.ru-ru
    # hunspellDicts.en-us
    hunspellDicts.en-us-large
    # hunspellDicts.en-gb-ise
    hunspellDicts.en-gb-large

    # /b/}

    # Gnome
    # /b/{

    dconf-editor
    gnome-tweaks
    raider # Permanently delete your files (also named File Shredder)
    gparted # Graphical disk partitioning tool

    # /b/}

    # Internet
    # /b/{

    google-chrome
    tor-browser

    # /b/}

    # Nix-related
    # /b/{

    nil # Yet another language server for Nix
    alejandra # The Uncompromising Nix Code Formatter

    # Generate Nix fetcher calls from repository URLs
    # Use example:
    #   $ nurl https://github.com/nix-community/patsh v0.2.0 2>/dev/null
    #   fetchFromGitHub {
    #     owner = "nix-community";
    #     repo = "patsh";
    #     rev = "v0.2.0";
    #     hash = "sha256-7HXJspebluQeejKYmVA7sy/F3dtU1gc4eAbKiPexMMA=";
    #   }
    nurl

    # /b/}
  ];

  environment.variables.XCURSOR_THEME = "Adwaita";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
