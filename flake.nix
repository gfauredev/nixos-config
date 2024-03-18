{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable

    # agenix.url = "github:ryantm/agenix"; # TODO Store secrets encrypted
    # sops-nix.url = "github:Mic92/sops-nix"; # TODO Store secrets encrypted

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    musnix.url = "github:musnix/musnix"; # Music production & realtime audio
  };

  outputs = { self, nixpkgs, lanzaboote, nixos-hardware, home-manager, musnix
    , ... }@inputs: {
      # NixOS config, available through 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        ##### Laptops #####
        griffin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # agenix.nixosModules.default # Secrets storage TODO for all systems
            # sops-nix.nixosModules.sops # Secrets storage TODO for all systems
            lanzaboote.nixosModules.lanzaboote # Secure boot
            nixos-hardware.nixosModules.framework-12th-gen-intel
            musnix.nixosModules.musnix # System improvements for audio
            ./system/pc/laptop/griffin # Griffin, a powerful and flying creature
            ./system/user/gf.nix # Myself
            ./system/virtualization.nix
          ];
        };
        chimera = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # lanzaboote.nixosModules.lanzaboote # Secure boot TEST
            nixos-hardware.nixosModules.common-cpu-intel # Hardware
            nixos-hardware.nixosModules.common-pc # Hardware
            nixos-hardware.nixosModules.common-pc-ssd # Hardware
            musnix.nixosModules.musnix # System improvements for audio
            ./system/pc/laptop/chimera # Chimera, a flying creature
            ./system/user/gf.nix # Myself
          ];
        };
        ##### Desktops #####
        typhon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            lanzaboote.nixosModules.lanzaboote # Secure boot
            nixos-hardware.nixosModules.common-cpu-amd # Hardware
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc # Hardware
            nixos-hardware.nixosModules.common-pc-ssd # Hardware
            musnix.nixosModules.musnix # System improvements for audio
            ./system/pc/typhon # Typhon, the most powerful creature
            ./system/user/gf.nix # Myself
            ./system/virtualization.nix
          ];
        };
        work = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            lanzaboote.nixosModules.lanzaboote # Secure boot
            nixos-hardware.nixosModules.common-pc # Hardware
            ./system/pc/work # PC used at work
            ./system/user/gf.nix # Myself
            ./system/virtualization.nix
          ];
        };
        ##### Servers #####
        cerberus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            lanzaboote.nixosModules.lanzaboote # Secure boot
            nixos-hardware.nixosModules.common-cpu-intel # Hardware related
            nixos-hardware.nixosModules.common-pc # Hardware related
            ./system/server/cerberus # Cerberus, a powerful creature with multiple heads
            ./system/virtualization.nix
          ];
        };
        ##### NixOS live ISO image, suitable for installation #####
        installer = nixpkgs.lib.nixosSystem {
          # Build with : nix build .#nixosConfigurations.installer.config.system.build.isoImage
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./system/installer.nix # Bootable ISO used to install NixOS
          ];
        };
      };

      # home-manager config, available through 'home-manager --flake .#username@hostname'
      homeConfigurations =
        # TODO cleaner terminal commands (nix functions)
        let
          alacritty = {
            name = "alacritty"; # Name of the terminal
            cmd = "alacritty"; # Launch terminal
            exec =
              "alacritty --command"; # Option to execute a command in place of shell
            cd =
              "--working-directory"; # Option to launch terminal in a directory
            # Classed terminals (executes a command)
            monitoring =
              "alacritty --class monitoring --command"; # Monitoring terminal
            note = "alacritty --class note --command"; # Monitoring terminal
            menu =
              "alacritty --option window.opacity=0.7 --class menu --command"; # Menu terminal
          };
          wezterm = {
            name = "wezterm"; # Name of the terminal
            cmd = "wezterm start --always-new-process"; # Launch terminal
            exec = ""; # Option to execute a command in place of shell
            cd = "--cwd"; # Option to launch terminal in a directory
            # Classed terminals (executes a command)
            monitoring = "wezterm start --class monitoring"; # Monitoring
            note = "wezterm start --class note"; # Note
            menu =
              "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
          };
          location = "$HOME/.config/flake"; # This flake location
        in {
          "gf@griffin" = home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit inputs;
              hwmon = "3/temp1_input";
              term = wezterm;
              location = location;
            };
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home/gf # Myself’s home
              ./home/module/remap # XCompose & Inputs remaps
              ./home/module/hyprland/griffin.nix # Griffin’s specific Hyprland
              ./home/module/waybar # Wayland Bar
              ./home/module/virtualization.nix # Virtualization
              ./home/module/audio.nix # Audio & Music creation
              ./home/module/video.nix # Video & Animation creation
              ./home/module/photo.nix # Photo & Images creation
              ./home/module/model.nix # 3D and schematics modeling and hardware creation
              ./home/module/social.nix # Social interaction
              ./home/module/media # Media consuming and editing
              ./home/module/lapce # New text editor to test
            ];
          };
          "gf@typhon" = home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit inputs;
              hwmon = "2/temp3_input";
              term = wezterm;
              location = location;
            };
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home/gf # Myself’s home
              ./home/module/remap # XCompose & Inputs remaps
              ./home/module/hyprland/typhon.nix # Typhon’s specific Hyprland
              ./home/module/waybar/widescreen.nix # Wayland Bar for wide screens
              ./home/module/virtualization.nix # Virtualization
              ./home/module/audio.nix # Audio & Music creation
              ./home/module/video.nix # Video & Animation editing
              ./home/module/photo.nix # Photo & Images creation
              ./home/module/model.nix # 3D and schematics modeling and hardware creation
              ./home/module/social.nix # Social interaction
              ./home/module/media # Media consuming and editing
              # ./home/module/compositing.nix # 3D and special effects
              ./home/module/lapce # New text editor to test
            ];
          };
          "gf@work" = home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit inputs;
              hwmon = "2/temp3_input"; # TEST
              term = wezterm;
              location = location;
            };
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home/gf # Myself’s home
              ./home/module/remap # XCompose & Inputs remaps
              ./home/module/hyprland # WM
              ./home/module/virtualization.nix # Virtualization
              ./home/module/media # Media consuming and editing
              ./home/module/lapce # New text editor to test
            ];
          };
        };
    };
}
