{
  description = "ramblehead's NixOS flake";

  inputs = {
    # e.g. flake-utils.lib.eachDefaultSystem (system: ...)
    flake-utils.url = "github:numtide/flake-utils";

    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # alacritty-flake = {
    #   url = "path:./hm/programs/cargo-alacritty";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    dotfiles = {
      url = "git+file:./dotfiles";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: rec {
    flake-root = ./.;
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.rh-krancher = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ({
          config,
          pkgs,
          inputs,
          ...
        }: {
          nixpkgs.overlays = [
            (import ./overlays/mc)
          ];
        })

        ./configuration.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed
        # automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.rh = import ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
          home-manager.extraSpecialArgs = {
            inherit self;
            inherit inputs;
          };
        }

        ./lib/current-system-packages.nix
      ];
    };

    homeConfigurations."rh-krancher" = home-manager.lib.homeManagerConfiguration {
      # pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          (import ./overlays/mc)
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
        inherit flake-root;
      };
    };

    homeConfigurations."qt-dl1" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          (import ./overlays/mc)
        ];
        config.allowUnfree = true;
      };

      modules = [
        ./hm/hosts/qt-dl1.nix
        ./hm/users/root.nix
      ];

      extraSpecialArgs = {
        inherit self;
        inherit inputs;
        inherit flake-root;
      };
    };

    homeConfigurations."rh" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      modules = [./hm/users/rh.nix];

      extraSpecialArgs = {
        inherit self;
        inherit inputs;
        inherit flake-root;
      };
    };
  };
}
