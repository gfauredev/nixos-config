{
  # TODO Add these lines to the ninja config
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      modules = [
        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        nixos-hardware.nixosModules.framework-12th-gen-intel
      ];
    };
  };
}
