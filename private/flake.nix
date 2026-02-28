{
  description = "Guilhem Fauré’s Private NixOS Configurations";
  inputs = {
    self.submodules = true; # Force usage of git submodules sub flakes
    public.url = ./public; # Most of the config in this public Git repository
    # sops-nix.url = "github:Mic92/sops-nix"; # Encrypted secrets management
    # agenix.url = "github:ryantm/agenix"; # Encrypted secrets management
  };
  outputs =
    { self, public }:
    let
      user-def = import ./user.nix; # Common users configurations
    in
    {
      nixosConfigurations = public.nixosConfigurations // {
        griffin = public.nixosConfigurations.griffin.extendModules {
          modules = [
            ./system
            { user-def = user-def; }
          ];
        };
        live = public.nixosConfigurations.live.extendModules {
          modules = [
            ./system
            { user-def = user-def; }
            { environment.etc.config-flake.source = self; } # Include this repo
          ];
        };
      };
      defaultPackage.x86_64-linux = self.nixosConfigurations.live.config.system.build.isoImage;
      homeConfigurations = public.homeConfigurations // {
        "${user-def.default.name}@griffin" =
          public.homeConfigurations."${user-def.default.name}@griffin".extendModules
            {
              modules = [
                ./home
                { user = user-def.default; }
              ];
            };
      };
    };
}
