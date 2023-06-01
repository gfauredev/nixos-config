{
  description = "Guilhem Fauré’s systems and homes configurations";

  inputs =
    let
      version = "23.05"; # NixOS version of stable inputs
    in
    {
      # Primary nixpkgs repository
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      # Stable nixpkgs repository
      # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-${version}";
      # Primary Home Manager repository
      home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs than system
      };
      # Stable Home Manager repository
      # home-manager-stable = {
      #   url = "github:nix-community/home-manager/release-${version}";
      #   inputs.nixpkgs.follows = "nixpkgs-stable"; # Use same stable nixpkgs than system
      # };
    };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      # Systems
      nixosConfigurations = {
        # Main desktop
        desktop0 = lib.nixosSystem {
          inherit system;
          modules = [
            ./system.nix/desktop/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gf = {
                imports = [ ./home.nix/gf.nix ];
              };
            }
          ];
        };
        # Framework laptop
        laptop0 = lib.nixosSystem {
          inherit system;
          modules = [
            ./system.nix/laptop/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gf = {
                imports = [ ./home.nix/gf.nix ];
              };
            }
          ];
        };
      };

      # Homes
      # hmConfig = {
      #   gf = home-manager.lib.homeManagerConfiguration {
      #     inherit system pkgs;
      #     username = "gf";
      #     homeDirectory = "/home/gf";
      #     configuration = {
      #       imports = [ ./home.nix/gf.nix ];
      #     };
      #   };
      # };
    };
}
