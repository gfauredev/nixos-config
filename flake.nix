{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # NixOS 23.05

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    musnix.url = "github:musnix/musnix"; # Realtime audio
  };

  outputs = { self, nixpkgs, lanzaboote, nixos-hardware, home-manager, musnix }@inputs: {
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      ninja = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.framework-12th-gen-intel
          lanzaboote.nixosModules.lanzaboote
          musnix.nixosModules.musnix # System improvements for audio
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/ninja.nix # Light & quick laptop : ninja
          ./system/pc/gf.nix # Main user
          ./system/pc/laptop.nix
          # ./system/realtime.nix # TODO adapt for laptops
          ./system/wireless.nix
          ./system/pc/remap.nix
          ./system/print-scan.nix
          ./system/virtualisation.nix
        ];
      };
      knight = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd # Hardware related
          nixos-hardware.nixosModules.common-gpu-nvidia # Hardware related
          nixos-hardware.nixosModules.common-pc # Hardware related
          nixos-hardware.nixosModules.common-pc-ssd # Hardware related
          musnix.nixosModules.musnix # System improvements for audio
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/knight.nix # Heavy & strong desktop : knight
          ./system/pc/gf.nix # Main user
          ./system/realtime.nix
          ./system/wireless.nix
          ./system/pc/remap.nix
          ./system/pc/xorg.nix # TEST might be useless
          ./system/print-scan.nix
          ./system/gaming.nix
        ];
      };
      hydra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/headless/hydra.nix # Multi-purpose hypervisor : hydra
          ./system/virtualisation.nix
        ];
      };
      scout = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/scout.nix # Light laptop for travel : scout
          ./system/pc/gf.nix # Main user
          ./system/pc/laptop.nix
          ./system/wireless.nix
          ./system/pc/remap.nix
          ./system/print-scan.nix
        ];
      };
    };

    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "gf@ninja" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home # Default, like text editor # TODO auto import default.nix
          ./home/zsh.nix # Shell config
          ./home/gf.nix # My main user
          ./home/wayland.nix # wayland common
          ./home/hyprland.nix # sway window manager
          ./home/waybar.nix # wayland bar
          ./home/rofi.nix # wayland launcher
          ./home/hard.nix # Hardware creation
          ./home/audio.nix # Audio & Music creation
          ./home/photo.nix # Photo & Images creation
          ./home/media.nix # Media consuming
          ./home/social.nix # Social interaction
          # ./home/sway.nix # sway window manager
        ];
      };
      "gf@knight" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home # Default, like text editor # TODO auto import default.nix
          ./home/zsh.nix # Shell config
          ./home/gf.nix # My main user
          ./home/i3.nix # i3 window manager
          ./home/hard.nix # Hardware creation
          ./home/audio.nix # Audio & Music creation
          ./home/video.nix # Video & Animation creation
          ./home/photo.nix # Photo & Images creation
          ./home/social.nix # Social interaction
          ./home/media.nix # Media consuming
          ./home/gaming.nix # Video gaming
        ];
      };
    };
  };
}
