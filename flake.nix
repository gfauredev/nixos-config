{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable

    # agenix.url = "github:ryantm/agenix"; # TODO Store secrets encrypted
    sops-nix.url = "github:Mic92/sops-nix"; # TODO Store secrets encrypted

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    musnix.url = "github:musnix/musnix"; # Music production & realtime audio
  };

  # TODO test if using @inputs is necessary
  outputs = { self, nixpkgs, sops-nix, lanzaboote, nixos-hardware, home-manager, musnix, ... }@inputs: {
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      # Laptops
      # Dragon, a powerful and flying creature
      ninja = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          sops-nix.nixosModules.sops # Secrets storage
          nixos-hardware.nixosModules.framework-12th-gen-intel
          musnix.nixosModules.musnix # System improvements for audio
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/ninja.nix # Light & quick laptop : ninja
          ./system/pc/gf.nix # Main user
          ./system/pc/laptop.nix
          ./system/pc/remap.nix
          ./system/print-scan.nix
          ./system/virtualization.nix
          ./system/pc/xorg.nix # For compatibility
        ];
      };
      # Wyvern, a flying creature
      wyvern = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          nixos-hardware.nixosModules.common-cpu-intel # Hardware related
          nixos-hardware.nixosModules.common-pc # Hardware related
          nixos-hardware.nixosModules.common-pc-ssd # Hardware related
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/scout.nix # Light laptop for travel : scout
          ./system/pc/gf.nix # Main user
          ./system/pc/laptop.nix
          ./system/pc/remap.nix
          ./system/print-scan.nix
        ];
      };
      # Desktops
      # Kraken, a very powerful creature
      knight = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          nixos-hardware.nixosModules.common-cpu-amd # Hardware related
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc # Hardware related
          nixos-hardware.nixosModules.common-pc-ssd # Hardware related
          musnix.nixosModules.musnix # System improvements for audio
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/knight.nix # Heavy & strong desktop : knight
          ./system/pc/gf.nix # Main user
          ./system/pc/remap.nix
          ./system/print-scan.nix
          ./system/virtualization.nix
          # ./system/pc/gaming.nix
          ./system/pc/xorg.nix # For compatibility
        ];
      };
      # Servers
      # Cerberus, a powerful creature with multiple heads (hypervisor and orchestrator)
      cerberus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          nixos-hardware.nixosModules.common-cpu-intel # Hardware related
          nixos-hardware.nixosModules.common-pc # Hardware related
          ./system
          ./system/headless # A server
          ./system/headless/cerberus.nix # Multi-purpose : cerberus
          ./system/virtualization.nix
        ];
      };
      # NixOS live ISO image, suitable for installation
      # Prometheus, a creator titan
      prometheus = nixpkgs.lib.nixosSystem {
        # Built with : nix build .#nixosConfigurations.installer.config.system.build.isoImage
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # agenix.nixosModules.default # Secrets storage
          # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
          ./system
          ./system/installer.nix # Bootable ISO used to install NixOS
        ];
      };
    };

    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations =
      let
        alacritty = {
          # TODO create nix functions & modules to do that cleaner
          name = "alacritty"; # Name of the terminal
          cmd = "alacritty"; # Command to launch terminal
          exec = "alacritty --command"; # Option to execute a command in place of shell
          monitoring = "alacritty --class monitoring --command"; # Monitoring terminal
          note = "alacritty --class note --command"; # Monitoring terminal
          menu = "alacritty --option window.opacity=0.7 --class menu --command"; # Menu terminal
          cd = "--working-directory"; # Option to launch terminal in a directory
        };
        wezterm = {
          # TODO create nix functions & modules to do that cleaner
          name = "wezterm"; # Name of the terminal
          cmd = "wezterm"; # Command to launch terminal
          transparent = "--config window_background_opacity=0.7"; # Option to transparent
          exec = "start"; # Option to execute a command in place of shell
          class = "--class"; # Option to define a class for the window
          cd = "--cwd"; # Option to launch terminal in a directory
        };
      in
      {
        "gf@ninja" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            hwmon = "4/temp3_input";
            term = alacritty;
          };
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home # Default, like text editor
            ./home/gf # My main user
            ./home/hyprland # Hyprland window manager
            ./home/hyprland/ninja.nix # ninja’s specific Hyprland
            ./home/waybar # wayland bar
            ./home/rofi # wayland launcher
            ./home/virtualization.nix # Virtualization
            ./home/audio.nix # Audio & Music creation
            ./home/video.nix # Video & Animation creation
            ./home/photo.nix # Photo & Images creation
            ./home/model.nix # 3D and schematics modeling and hardware creation
            ./home/media.nix # Media consuming
            ./home/social.nix # Social interaction
            ./home/i3.nix # XOrg compatibility wm
            # ./home/window-manager.nix # wayland common # Included by WM
            # ./home/retrogaming.nix # Video gaming
          ];
        };
        "gf@knight" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            hwmon = "2/temp3_input";
            term = alacritty;
          };
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home # Default, like text editor
            ./home/gf # My main user
            ./home/hyprland # Hyprland window manager
            ./home/hyprland/knight.nix # knight’s specific Hyprland
            ./home/waybar # wayland bar
            ./home/waybar/widescreen.nix # wayland bar for wide screens
            ./home/rofi # wayland launcher
            ./home/virtualization.nix # Virtualization
            ./home/audio.nix # Audio & Music creation
            ./home/video.nix # Video & Animation editing
            # ./home/compositing.nix # 3D and special effects
            ./home/photo.nix # Photo & Images creation
            ./home/model.nix # 3D and schematics modeling and hardware creation
            ./home/social.nix # Social interaction
            ./home/media.nix # Media consuming
            # ./home/gaming.nix # Video gaming
            ./home/i3.nix # XOrg compatibility wm
            # ./home/window-manager.nix # wayland common # Included in WM
          ];
        };
      };
  };
}
