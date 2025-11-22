{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./alias.nix
    ./nushell
    ./zsh.nix
    ./pulsemixer
  ];
  home.packages =
    with pkgs;
    with lib;
    let
      archive = writeScriptBin "archive" readFile ./script/archive.sh;
      backup = writeScriptBin "back" readFile ./script/backup.sh;
      # TODO make this script a package available in this flake’s nix shell (dev environment)
      configure = writeScriptBin "cfg" ''
        cd ${config.location}
        # direnv exec . # FIXME Seems not using direnv properly inside editor, LSPs don’t always work
        systemd-inhibit --what=shutdown:sleep --who=cfg --why=Configuring ${
          writeScript "configure" readFile ./script/configure.sh
        }/configure "$@"
      '';
      date-edit = writeScriptBin "de" readFile ./script/date-edit.sh;
      extract = writeScriptBin "ex" readFile ./script/extract.sh;
      init-dev-env = writeScriptBin "dev" readFile ./script/init-dev-env.sh;
      mtp-mount = writeScriptBin "mount.mtp" readFile ./script/mtp.sh;
      present-pdf = writeScriptBin "present" readFile ./script/present.sh;
      smart-commit = writeScriptBin "cmt" readFile ./script/smart-commit.sh;
      smart-terminal = writeScriptBin "t" ''
        TERM_EXEC=${config.term.exec}
        ${readFile ./script/smart-terminal.sh}
      '';
      typst-compile = writeScriptBin "typ" readFile ./script/typ.sh;
      usb-mount = writeScriptBin "mount.usb" readFile ./script/usb.sh;
    in
    [
      archive # Quickly move a directory inside ~/archive/
      backup # Backup with restic or rsync
      configure # Configure this flake config
      date-edit # Open text files, prepend current date to the first one
      extract # Extract any compressed file
      init-dev-env # Initialize a Nix Flake based development environment
      mtp-mount # Quickly mount or unmount Android device(s) mounted in ~/mtp
      present-pdf # Open detached pdfpc to present a PDF slide
      smart-commit # Quickly commit or amend, lint message
      smart-terminal # Open a terminal quickly with first parameter always cd
      typst-compile # Compile the latest edited Typst file in current dir
      usb-mount # Quickly mount or unmount a USB device in ~/usb
      ripgrep-all # ripgrep for non-text files
      trash-cli # Manage a trash from CLI # Needed with Nushell ?
    ];

  home = {
    # TODO better https://wiki.nixos.org/wiki/Environment_variables
    sessionVariables = {
      SHELL = "nu";
      BAT_PAGING = "never";
      PAGER = "ov";
    };
    shell = {
      enableShellIntegration = false; # Only for the following
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };

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
    yazi.enable = true;
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
    yazi = {
      enableNushellIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = false;
    };
  };

  xdg.configFile = {
    "ov/config.yaml".source = ./ov.yaml;
    "commitlintrc.yaml".source = ./commitlintrc.yaml;
    "backup-exclude".source = ./script/backup-exclude;
  };
}
