{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05"; # NixOS Stable

    # agenix.url = "github:ryantm/agenix"; # TODO Store secrets encrypted
    # sops-nix.url = "github:Mic92/sops-nix"; # TODO Store secrets encrypted

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    musnix.url = "github:musnix/musnix"; # Music production & realtime audio

    # anyrun = {
    #   url = "github:Kirottu/anyrun";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # TODO: see if possible to use either @inputs or a comprehensive list of inputs
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      stablepkgs = inputs.nixpkgs-stable.legacyPackages.${system};
    in {
      # NixOS config, available through 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        ##### Laptops #####
        griffin = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs stablepkgs; };
          modules = [
            # agenix.nixosModules.default # Secrets storage TODO for all systems
            # sops-nix.nixosModules.sops # Secrets storage TODO for all systems
            inputs.lanzaboote.nixosModules.lanzaboote # Secure boot
            inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
            inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime # eGPU
            inputs.musnix.nixosModules.musnix # System improvements for audio
            ./system/pc/laptop/griffin # Griffin, a powerful and flying creature
            ./system/user/gf.nix # TODO make it an option of systems (may include home)
            ./system/virtualization.nix # TODO make it an option of systems
            ./system/pc/gaming.nix # TODO make it an option of systems
          ];
        };
        chimera = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            # inputs.lanzaboote.nixosModules.lanzaboote # Secure boot TEST
            inputs.nixos-hardware.nixosModules.common-cpu-intel # Hardware
            inputs.nixos-hardware.nixosModules.common-pc # Hardware
            inputs.nixos-hardware.nixosModules.common-pc-ssd # Hardware
            inputs.musnix.nixosModules.musnix # System improvements for audio
            ./system/pc/laptop/chimera # Chimera, a flying creature
          ];
        };
        ##### Desktops #####
        # typhon = nixpkgs.lib.nixosSystem {
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     inputs.lanzaboote.nixosModules.lanzaboote # Secure boot
        #     inputs.nixos-hardware.nixosModules.common-cpu-amd # Hardware
        #     inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        #     inputs.nixos-hardware.nixosModules.common-pc # Hardware
        #     inputs.nixos-hardware.nixosModules.common-pc-ssd # Hardware
        #     inputs.musnix.nixosModules.musnix # System improvements for audio
        #     ./system/pc/typhon # Typhon, the most powerful creature
        #   ];
        # };
        # work = nixpkgs.lib.nixosSystem {
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     inputs.lanzaboote.nixosModules.lanzaboote # Secure boot
        #     inputs.nixos-hardware.nixosModules.common-pc # Hardware
        #     ./system/pc/work # PC used at work
        #   ];
        # };
        ##### Servers #####
        cerberus = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.lanzaboote.nixosModules.lanzaboote # Secure boot
            inputs.nixos-hardware.nixosModules.common-cpu-intel # Hardware related
            inputs.nixos-hardware.nixosModules.common-pc # Hardware related
            ./system/server/cerberus # Cerberus, a powerful creature with multiple heads
            # ./system/virtualization.nix # TODO make it an option of systems
          ];
        };
        ##### NixOS live ISO image, suitable for installation #####
        installer = nixpkgs.lib.nixosSystem {
          # Build with : nix build .#nixosConfigurations.installer.config.system.build.isoImage
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
            name = "alacritty"; # Name of the terminal (for matching)
            cmd = "alacritty"; # Launch terminal
            exec = "--command"; # Option to execute a command in place of shell
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
            name = "wezterm"; # Name of the terminal (for matching)
            cmd = "wezterm start --always-new-process"; # Launch terminal
            exec = ""; # Option to execute a command in place of shell
            cd = "--cwd"; # Option to launch terminal in a directory
            # Classed terminals (executes a command)
            monitoring = "wezterm start --class monitoring"; # Monitoring
            note = "wezterm start --class note"; # Note
            menu =
              "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
          };
          location = "/config"; # This Flake location
        in {
          "gf@griffin" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs stablepkgs;
              term = alacritty;
              term-alt = wezterm;
              location = location;
            };
            modules = [ # TODO clean this down to one module
              ./home/gf.nix # Myself’s home
              ./home/wayland/griffin.nix # Griffin’s GUI
              ./home/tool # Tooling, mostly technical
              ./home/media # Media consuming and editing
            ];
          };
          "gf@chimera" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs stablepkgs;
              term = alacritty;
              term-alt = wezterm;
              location = location;
            };
            modules = [ # TODO clean this down to one module
              ./home/gf.nix # Myself’s home
              ./home/wayland/griffin.nix # Griffin’s GUI
              # ./home/tool # Tooling, mostly technical
              # ./home/media # Media consuming and editing
            ];
          };
          # "gf@typhon" = inputs.home-manager.lib.homeManagerConfiguration {
          #   extraSpecialArgs = {
          #     inherit inputs;
          #     term = alacritty;
          #     term-alt = wezterm;
          #     location = location;
          #   };
          #   modules = [
          #     ./home/gf.nix # Myself’s home
          #     ./home/wayland/typhon.nix # Typhon’s GUI
          #     ./home/tool # Tooling, mostly technical
          #     ./home/media # Media consuming and editing
          #   ];
          # };
          # "gf@work" = inputs.home-manager.lib.homeManagerConfiguration {
          #   extraSpecialArgs = {
          #     inherit inputs;
          #     term = alacritty;
          #     term-alt = wezterm;
          #     location = location;
          #   };
          #   modules = [
          #     ./home/gf.nix # Myself’s home
          #     ./home/wayland # Wayland WM & related
          #     ./home/tool # Tooling, mostly technical
          #     ./home/media # Media consuming and editing
          #   ];
          # };
        };
    };
}
