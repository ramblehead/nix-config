# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = let
    # nproc = "${toString (builtins.length (builtins.match "processor" (builtins.readFile /proc/cpuinfo)))}";
    nproc = 12;
  in [
    # "default_hugepagesz=1G"
    "hugepagesz=1G"
    "hugepages=${toString nproc}"
    # "amdgpu.si_support=1"
    # "amdgpu.cik_support=1"
    # "radeon.si_support=0"
    # "radeon.cik_support=0"
  ];

  hardware.amdgpu.initrd.enable = true;
  # hardware.amdgpu.opencl.enable = true;
  # hardware.amdgpu.amdvlk.enable = true;
  # hardware.amdgpu.amdvlk.supportExperimental.enable = true;
  # hardware.amdgpu.amdvlk.support32Bit.enable = true;

  # hardware.enableRedistributableFirmware = true;

  hardware.opengl = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
    # setLdLibraryPath = true;

    # package = pkgs.linuxKernel.packages.linux_zen.amdgpu-pro;
    # package = (config.boot.kernelPackages.rocm-opencl-icd);
    # package = (config.boot.kernelPackages.amdgpu-pro);
    # package32 = pkgs.linuxKernel.packages.linux_zen.amdgpu-pro;
    # extraPackages = with pkgs; [
    #   rocmPackages.clr
    #   rocm-opencl-icd
    #   rocm-opencl-runtime
    #   rocmPackages.clr
    #   rocmPackages.clr.icd
    # ];

    extraPackages = with pkgs; [
      rocmPackages_5.clr.icd
      # rocmPackages_5.clr
      rocmPackages_5.rocm-runtime
      rocmPackages_5.rocm-core

      rocmPackages_5.rocblas
      rocmPackages_5.hipblas

      # rocmPackages_5.llvm.lld
      # rocmPackages_5.llvm.llvm
      # rocmPackages_5.llvm.libc
      # rocmPackages_5.llvm.libcxx
      # rocmPackages_5.llvm.libcxxabi
      # rocmPackages_5.rocm-smi

      # rocmPackages_5.hipcc

      ocl-icd
      # khronos-ocl-icd-loader
      # rocm-opencl-icd
      # rocm-opencl-runtime
    ];
  };

  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;

  #   extraPackages = with pkgs; [
  #     rocm-opencl-icd
  #     rocm-opencl-runtime
  #     rocmPackages.rocm-runtime
  #     amdvlk
  #   ];

  #   extraPackages32 = with pkgs; [
  #     driversi686Linux.amdvlk
  #   ];
  # };

  # systemd.tmpfiles.rules = let
  #   rocmEnv = pkgs.symlinkJoin {
  #     name = "rocm-combined";
  #     paths = with pkgs.rocmPackages_5; [
  #       rocblas
  #       hipblas
  #       clr
  #     ];
  #   };
  # in [
  #   "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  # ];

  # This is necesery because many programs hard-code the path to hip.
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  ];

  # As of ROCm 4.5, AMD has disabled OpenCL on Polaris based cards. So this is
  # needed if you have a 500 series card.
  environment.variables.ROC_ENABLE_PRE_VEGA = "1";

  networking.hostName = "vostok"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.videoDrivers = [ "amdgpu-pro" ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "numpad:microsoft";
    variant = "";
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    chromium
    telegram-desktop
    google-chrome

    hack-font

    hunspell
    hunspellDicts.ru-ru
    # hunspellDicts.en-us
    hunspellDicts.en-us-large
    # hunspellDicts.en-gb-ise
    hunspellDicts.en-gb-large

    # Equivalent of the apt-get build-dep
    gcc
    gnumake
    pkg-config
    autoconf
    automake
    libtool
    cmake
    python3

    # PulseAudio Volume Control
    pavucontrol
    wl-clipboard

    clinfo
    radeontop
    opencl-info
    rocmPackages_5.rocminfo
    # linuxKernel.packages.linux_zen.amdgpu-pro

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
  ];

  # environment.variables.EDITOR = "micro";
  # environment.variables.EDITOR = "nvim";
  environment.variables.XCURSOR_THEME = "Adwaita";
  environment.variables.PATH = lib.mkAfter "/etc/profiles/per-user/root/bin";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.openssh.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;

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
