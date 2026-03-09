{
  description = "ramblehead's NixOS and Nix flake";

  inputs = {
    # e.g. flake-utils.lib.eachDefaultSystem (system: ...)
    flake-utils.url = "github:numtide/flake-utils";

    # This should be removed after dropping Debian Bookworm desctop
    nixpkgs-25_05.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
    };

    nixgl = {
      # This commit seems to break my setup:
      # https://github.com/nix-community/nixGL/pull/190
      # url = "github:nix-community/nixGL/d47b0db35dfa693c10f7c378043dcc6121d3f4ec";
      url = "github:nix-community/nixGL";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # helix = {
    #   url = "github:helix-editor/helix/master";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # # A graphical app store for Nix
    # nix-software-center = {
    #   url = "github:snowfallorg/nix-software-center";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Fenix provides profiles of rust toolchains.
    # see https://rust-lang.github.io/rustup/concepts/profiles.html
    fenix = {
      # Nightly branch
      # url = "github:nix-community/fenix";
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # wezterm = {
    #   # Current MS Windows release version
    #   url = "github:wezterm/wezterm/20240203-110809-5046fc22?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # # Pure and reproducible packaging of binary distributed rust toolchains.
    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    dotfiles = {
      # url = "git+file:./dotfiles";
      url = "git+file:///home/rh/box/nix-config/dotfiles";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    # Root directory of the flake (current folder), used to reference files and
    # subdirectories from other modules in a way that follows the flake's file
    # structure.
    flakeRoot = ./.;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.vostok = nixpkgs.lib.nixosSystem (let
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      inherit system;

      specialArgs = {
        inherit inputs;
        inherit pkgs-unstable;
        inherit flakeRoot;
      };

      modules = [
        ({
          # config,
          # pkgs,
          inputs,
          ...
        }: {
          nixpkgs.overlays = [
            (import ./overlays/mc)
            inputs.fenix.overlays.default
            # inputs.rust-overlay.overlays.default

            # (final: prev: {
            #   cups = pkgs-unstable.cups;
            #   hplipWithPlugin = pkgs-unstable.hplipWithPlugin;
            # })

            # (final: prev: {
            #   gtksourceview5 = prev.gtksourceview5.overrideAttrs (old: {
            #     # Option A: Disable tests completely (fastest, usually safe)
            #     doCheck = false;

            #     # Option B: Keep tests but give them much more time (if you want to verify)
            #     # preCheck = old.preCheck or "" + ''
            #     #   export MESON_TEST_TIMEOUT_MULTIPLIER=10
            #     # '';
            #   });
            # })

            # (final: prev: {
            #   cups = prev.cups.overrideAttrs (old: rec {
            #     version = "2.4.14";
            #     src = prev.fetchurl {
            #       url = "https://github.com/OpenPrinting/cups/releases/download/v${version}/cups-${version}-source.tar.gz";
            #       hash = "sha256-ZgKIAg3W95yveZgRxMGjIHpIaJiZrCCTlZ1wo73Ldpk=";
            #     };
            #   });
            # })
          ];

          nixpkgs.config.allowUnfree = true;
        })

        ./nixos/hosts/vostok/configuration.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed
        # automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.rh = import ./hm/users/rh-vostok.nix;
          home-manager.users.root = import ./hm/users/root.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
          home-manager.extraSpecialArgs = {
            inherit self;
            inherit inputs;
            inherit flakeRoot;
            # isNixOS = true;
          };
        }

        # List current system packages in /etc/current-system-packages
        ./lib/current-system-packages.nix
      ];
    });

    nixosConfigurations.arilou = nixpkgs.lib.nixosSystem (let
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      inherit system;

      specialArgs = {
        inherit inputs;
        inherit pkgs-unstable;
        inherit flakeRoot;
      };

      modules = [
        ({
          # config,
          # pkgs,
          inputs,
          ...
        }: {
          nixpkgs.overlays = [
            (import ./overlays/mc)
            inputs.fenix.overlays.default
            # inputs.rust-overlay.overlays.default
          ];

          nixpkgs.config.allowUnfree = true;
        })

        ./nixos/hosts/arilou/configuration.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed
        # automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.rh = import ./hm/users/rh-arilou.nix;
          home-manager.users.root = import ./hm/users/root.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
          home-manager.extraSpecialArgs = {
            inherit self;
            inherit inputs;
            inherit flakeRoot;
            # isNixOS = true;
          };
        }

        # List current system packages in /etc/current-system-packages
        ./lib/current-system-packages.nix
      ];
    });

    homeConfigurations."rh-krancher" = home-manager.lib.homeManagerConfiguration {
      # pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          (import ./overlays/mc)
          # inputs.fenix.overlays.default
        ];
        config.allowUnfree = true;
      };

      modules = [
        ./hm/hosts/rh-krancher.nix
        ./hm/users/root.nix
      ];

      extraSpecialArgs = {
        inherit self;
        inherit inputs;
        inherit flakeRoot;
      };
    };

    homeConfigurations."qt-dl1" = home-manager.lib.homeManagerConfiguration (let
      pkgs-25_05 = import inputs.nixpkgs-25_05 {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          (import ./overlays/mc)
          inputs.fenix.overlays.default
          # inputs.rust-overlay.overlays.default
        ];
        config.allowUnfree = true;
      };

      modules = [
        ./hm/hosts/qt-dl1.nix
        ./hm/users/root.nix
      ];

      extraSpecialArgs = {
        inherit self;
        inherit pkgs-25_05;
        inherit pkgs-unstable;
        inherit inputs;
        inherit flakeRoot;
      };
    });

    homeConfigurations."rh@qt-dl1" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      modules = [
        ./hm/users/rh.nix
      ];

      extraSpecialArgs = {
        inherit self;
        inherit inputs;
        inherit flakeRoot;
        isNixOS = false;
      };
    };

    homeConfigurations."glider" = home-manager.lib.homeManagerConfiguration (let
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          (import ./overlays/mc)
          inputs.fenix.overlays.default
        ];
        config.allowUnfree = true;
      };

      modules = [
        ./hm/hosts/glider.nix
        ./hm/users/root.nix
      ];

      extraSpecialArgs = {
        inherit self;
        inherit pkgs-unstable;
        inherit inputs;
        inherit flakeRoot;
      };
    });

    homeConfigurations."rh@glider" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      modules = [
        ./hm/users/rh.nix
      ];

      extraSpecialArgs = {
        inherit self;
        inherit inputs;
        inherit flakeRoot;
        isNixOS = false;
      };
    };
  };
}
