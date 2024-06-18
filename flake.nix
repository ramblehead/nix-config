{
  description = "ramblehead's NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mcedit-syntax = {
    #   url = "github:svanderburg/nix-syntax-for-mcedit";
    #   flake = false;
    # };

    helix.url = "github:helix-editor/helix/master";

    # alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

    dotfiles = {
      url = "git+file:./dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: rec {
    # mcAttrs = {
    #   buildInputs = nixpkgs.legacyPackages.x86_64-linux.mc.buildInputs ++ (with nixpkgs.legacyPackages.x86_64-linux; [
    #     autoconf
    #     automake
    #     libtool
    #   ]);
    #   shellHook = ''
    #     export RH="test-x";
    #   '';
    # }; 
 
    # devShells = {
    #   x86_64-linux = {
    #     mc = nixpkgs.legacyPackages.x86_64-linux.mkShell mcAttrs;
    #   };
    # };


    nixosConfigurations.rh-krancher = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # ({ config, pkgs, ...}: {
        #   nixpkgs.overlays = [ alacritty-theme.overlays.default ];
        # })

        # ({ config, pkgs, mcAttrs, ... }: {
        #   nixpkgs.overlays = [
        #     # (self: super: {
        #     #   mc = super.mc.overrideAttrs (oldAttrs: {
        #     #     shellHook = ''
        #     #       export RH="test-x";
        #     #     '';

        #     #     # preConfigure = ''
        #     #     #   # Copy syntax file
        #     #     #   # cp ./nix.syntax misc/syntax/nix.syntax
        #     #     #   echo ${builtins.readFile ./nix.syntax} > misc/syntax/nix.syntax

        #     #     #   # Add syntax file to the list of data files to be installed
        #     #     #   sed -i -e "s|yxx.syntax|yxx.syntax nix.syntax|" misc/syntax/Makefile.am

        #     #     #   # Add Nix syntax to the syntax configuration
        #     #     #   sed -i -e '/unknown$/i \
        #     #     #   file ..\\*\\\\.nix$ Nix\\sExpression\
        #     #     #   include nix.syntax\
        #     #     #   ' misc/syntax/Syntax.in

        #     #     #   Regenerate configure script
        #     #     #   autoreconf -f -v -i
        #     #     #   ./autogen.sh
        #     #     # '';
        #     #     buildInputs = oldAttrs.buildInputs ++ [ pkgs.autoconf pkgs.automake pkgs.libtool ];
        #     #   });
        #     # })
        #     (self: super: {
        #       mc = super.mc.overrideAttrs (oldAttrs: {
        #         inherit (mcAttrs) shellHook buildInputs;

        #         # preConfigure = ''
        #         #   # Copy syntax file
        #         #   # cp ./nix.syntax misc/syntax/nix.syntax
        #         #   # echo ${builtins.readFile ./nix.syntax} > misc/syntax/nix.syntax
	# 	#   cp ${./nix.syntax} misc/syntax/nix.syntax

        #         #   # Add syntax file to the list of data files to be installed
        #         #   sed -i -e "s|yxx.syntax|yxx.syntax nix.syntax|" misc/syntax/Makefile.am

        #         #   # Add Nix syntax to the syntax configuration
        #         #   sed -i -e '/unknown$/i \
        #         #   file ..\\*\\\\.nix$ Nix\\sExpression\
        #         #   include nix.syntax\
        #         #   ' misc/syntax/Syntax.in

        #         #   # Regenerate configure script
        #         #   autoreconf -f -v -i
        #         # '';

        #         preConfigure = ''
        #           cp ${./nix.syntax} misc/syntax/nix.syntax
        #           sed -i -e "s|yxx.syntax|yxx.syntax nix.syntax|" misc/syntax/Makefile.am
        #           autoreconf -f -v -i
        #         '';

        #         # buildInputs = oldAttrs.buildInputs ++ [ pkgs.autoconf pkgs.automake pkgs.libtool ];
        #       });
        #     })
        #     # (self: super: {
        #     #   mc = super.mc.overrideAttrs (oldAttrs: rec {
        #     #     inherit (mcAttrs) buildInputs shellHook;
        #     #   });
        #     # })
        #   ];
        # })

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
          home-manager.extraSpecialArgs = { dotfiles = inputs.dotfiles; };
        }
      ];
    };
  };
}
