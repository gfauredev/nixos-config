{
  # TODO add these lines to audio.nix
  # see https://github.com/musnix/musnix
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    musnix = { url = "github:musnix/musnix"; };
  };
  outputs = inputs: rec {
    nixosConfigurations = {
      hostname = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [
            inputs.musnix.nixosModules.musnix
            ./configuration.nix
          ];
      };
    };
  };
}
