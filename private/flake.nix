{
  description = "Guilhem Fauré’s Private NixOS Configurations";
  inputs = {
    self.submodules = true; # Force usage of git submodules sub flakes
    public.url = ./public; # Most of the config in this public Git repository
    sops-nix.url = "github:Mic92/sops-nix"; # Encrypted secrets management
    # agenix.url = "github:ryantm/agenix"; # Encrypted secrets management
  };
  outputs =
    { self, public }:
    let
      user-def = import ./user.nix; # Common users configurations
      # Users
      gf = user-def.users.gf // {
        email = user-def.emails.gf;
      };
    in
    {
      nixosConfigurations = public.nixosConfigurations // {
        griffin = public.nixosConfigurations.griffin.extendModules {
          modules = [
            ./system
            { user-def = user-def; }
          ];
        };
      };
      defaultPackage.x86_64-linux = self.nixosConfigurations.live.config.system.build.isoImage;
      homeConfigurations = public.homeConfigurations // {
        "gf@griffin" = public.homeConfigurations."gf@griffin".extendModules {
          modules = [
            ./home
            { user = gf; }
          ];
        };
      };
    };
}
