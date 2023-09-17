{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # NixOS 23.05

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    musnix.url = "github:musnix/musnix"; # Realtime audio
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, musnix }@inputs: {
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      ninja = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.framework-12th-gen-intel
          # lanzaboote.nixosModules.lanzaboote
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
          ./system/pc/xorg.nix
          ./system/print-scan.nix
        ];
      };
      hydra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/headless/hydra.nix # Multi-purpose hypervisor : hydra
          ./system/headless/hypervisor.nix
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
      # installer = nixpkgs.lib.nixosSystem { # TODO this directly here
      #   system = "x86_64-linux";
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     ./system # TODO sub modules of defaults auto import default.nix
      #     ./system/headless/installer.nix # NixOS installer, ideally through SSH
      #     ./system/wireless.nix
      #   ];
      # };
    };

    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "gf@ninja" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./user # Default, like text editor # TODO auto import default.nix
          ./user/zsh.nix # Shell config
          ./user/gf.nix # My main user
          ./user/sway.nix # sway window manager
          # ./user/hard.nix # Hardware creation
          ./user/audio.nix # Audio & Music creation
          # ./user/photo.nix # Photo & Images creation
          ./user/media.nix # Media consuming
          ./user/social.nix # Social interaction
          # ./user/virtualisation.nix
        ];
      };
      "gf@knight" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./user # Default, like text editor # TODO auto import default.nix
          ./user/zsh.nix # Shell config
          ./user/gf.nix # My main user
          ./user/i3.nix # i3 window manager
          ./user/hard.nix # Hardware creation
          ./user/audio.nix # Audio & Music creation
          ./user/video.nix # Video & Animation creation
          ./user/photo.nix # Photo & Images creation
          ./user/social.nix # Social interaction
          ./user/media.nix # Media consuming
          ./user/game.nix # Video gaming
          ./user/virtualisation.nix
        ];
      };
    };

    # Used with `nix develop`
    devShells.x86_64-linux = {
      # doc = pkgs.mkShell { }; # Tools for documents, like pandoc, latex, typst
      # lua = pkgs.mkShell { };
      # web = pkgs.mkShell { };
      # python = pkgs.mkShell { };
      # java = pkgs.mkShell { };
      # rust = pkgs.mkShell { };
      # c = pkgs.mkShell { };
      # query = pkgs.mkShell { };
      # pentest = pkgs.mkShell { };
      # default = pkgs.mkShell { }; # TEST relevance
    };
  };
}
