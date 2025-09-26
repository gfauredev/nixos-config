{ lib, pkgs, ... }:
{
  imports = [
    ./alias.nix
    ./nushell
    ./zsh.nix
    ./pulsemixer
  ];
  home.packages =
    let
      init-dev-env = pkgs.writeScriptBin "dev" "${lib.readFile ./script/init-dev-env.sh}";
      smart-terminal = pkgs.writeScriptBin "t" "${lib.readFile ./script/smart-terminal.sh}";
      extract = pkgs.writeScriptBin "ex" "${lib.readFile ./script/extract.sh}";
      backup = pkgs.writeScriptBin "back" "${lib.readFile ./script/backup.sh}";
      clean-archive = pkgs.writeScriptBin "cleanarchive" "${lib.readFile ./script/clean-archive.sh}";
      configure = pkgs.writeScriptBin "configure" "${lib.readFile ./script/configure.sh}";
      smart-commit = pkgs.writeScriptBin "cmt" "${lib.readFile ./script/smart-commit.sh}";
      date-edit = pkgs.writeScriptBin "de" "${lib.readFile ./script/date-edit.sh}";
      present-pdf = pkgs.writeScriptBin "present" "${lib.readFile ./script/present.sh}";
      typst-compile = pkgs.writeScriptBin "typ" "${lib.readFile ./script/typ.sh}";
      usb-mount = pkgs.writeScriptBin "mount.usb" "${lib.readFile ./script/usb.sh}";
      mtp-mount = pkgs.writeScriptBin "mount.mtp" "${lib.readFile ./script/mtp.sh}";
      archive = pkgs.writeScriptBin "archive" "${lib.readFile ./script/archive.sh}";
    in
    with pkgs;
    [
      # Custom scripts
      init-dev-env # Initialize a Nix Flake based development environment
      smart-terminal # Open a terminal quickly with first parameter always cd
      extract # Extract any compressed file
      backup # Backup with restic or rsync
      clean-archive # Clean the ~/archive dir after a backup
      configure # Configure this flake config
      smart-commit # Quickly commit or amend, lint message
      date-edit # Open text files, prepend current date to the first one
      present-pdf # Open detached pdfpc to present a PDF slide
      typst-compile # Compile the latest edited Typst file in current dir
      usb-mount # Quickly mount or unmount a USB device in ~/usb
      mtp-mount # Quickly mount or unmount Android device(s) mounted in ~/mtp
      archive # Quickly move a directory inside ~/archive/
      # Development and general CLI tools
      trash-cli # Manage a trash from CLI # TEST if needed with Nushell
      ripgrep-all # ripgrep for non-text files
      # rustdesk # Modern remote desktop
      kalker # Evaluate math expression
      nixpkgs-review # Quickly review pull requests to nixpkgs TEST
      comma # Run any command from Nixpkgs
      # steam-run # Run in isolated FHS
      # manix # Nix documentation CLI
      watchexec # Run command when file changes
      hyperfine # Benchmark commands
      nickel # Modern configuration Nickel, Nix improvement
      cdrkit # ISO tools and misc
      commitlint-rs # Be consistent in commit messages
      # pipectl # Named pipes management (probably replaced by Nu’s job)
    ];

  programs = {
    starship.enable = true; # Smart prompt
    zoxide.enable = true; # Smart cd
    broot.enable = true; # Quick fuzzy file finder
    atuin.enable = true; # Cross shell, smart command history
    bat.enable = true; # Better cat with syntax highlighting
    fd.enable = true; # Better find
    ripgrep.enable = true; # Better grep
    bottom.enable = true; # Better top
    carapace.enable = true; # Cross shell completions
    eza.enable = false; # Better ls
    gh.enable = true; # GitHub official CLI
    fish.enable = true; # Friendly shell, to provide completions to Nushell
    gh-dash.enable = true; # GitHub dashboard
    jq.enable = true; # JSON parsing and request tool
    translate-shell.enable = true; # Google Translate CLI
    fastfetch.enable = true; # Quick system info
    less.enable = false; # Bugged, don’t respects lesskeys
    lesspipe.enable = false;
    distrobox.enable = false; # Quick tightly integrated containers
    distrobox = {
      enableSystemdUnit = true; # Auto rebuild containers
      containers = {
        cad = {
          image = "archlinux";
          # image = "alpine:3";
          # entry = true; # ?
          additional_packages = "mesa uv ruff python-lsp-server python-rope helix";
          init_hooks = ''
            cd
            uv init
            uv add cadquery build123d yacv-server
          '';
        };
      };
    };
    broot.settings = {
      default_flags = "dgps";
      special_paths = lib.mkForce { }; # Remove them
      verbs = [
        {
          invocation = "edit";
          key = "enter";
          shortcut = "e";
          external = "$EDITOR {file}:{line}";
          apply_to = "text_file";
          leave_broot = false;
          set_working_dir = true;
        }
      ];
    };
    atuin.settings = {
      enter_accept = true; # Don’t currently work on Nushell
      workspaces = true; # Filter commands executed in Git repo
      ctrl_n_shortcuts = true; # Ctrl+[1-9] quickly select cmd
      # filter_mode_shell_up_key_binding = "session";
    };
  };

  xdg.configFile = {
    "ov/config.yaml".source = ./ov.yaml;
    "commitlintrc.yaml".source = ./commitlintrc.yaml;
    "backup-exclude".source = ./script/backup-exclude;
  };
}
