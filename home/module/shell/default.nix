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
  ];
  home.packages =
    with pkgs;
    with lib;
    let
      backup = writeScriptBin "back" (readFile ./script/backup.sh);
      # TODO make this script a package available in this flake’s nix shell (dev environment)
      configure = writeScriptBin "cfg" ''
        cd ${config.location}
        systemd-inhibit --what=shutdown:sleep --who=cfg --why=Configuring --mode=block \
        ${writeScript "configure" (readFile ./script/configure.sh)} "$@"
      '';
      develop = writeScriptBin "dev" ''
        nix flake init --template ${config.dev-templates}#"$1"
        direnv allow
      '';
      date-edit = writeScriptBin "de" (readFile ./script/date-edit.sh);
      drive = writeScriptBin "drive" (readFile ./script/drive.sh);
      extract = writeScriptBin "ex" (readFile ./script/extract.sh);
      inhibit = writeScriptBin "inhib" (readFile ../launcher/vicinae/scripts/inhib.sh);
      smart-commit = writeScriptBin "cmt" (readFile ./script/smart-commit.sh);
      smart-terminal = writeScriptBin "t" ''
        TERM_EXEC=${config.term.exec}
        ${readFile ./script/smart-terminal.sh}
      '';
      typst-compile = writeScriptBin "typ" (readFile ./script/typ.sh);
      usb-mount = writeScriptBin "mount.usb" (readFile ./script/usb.sh);
      timezone = writeScriptBin "tz" ''
        tz=$(${pkgs.curl}/bin/curl -fsS https://ipapi.co/timezone)" && [ -n "$tz" ] && timedatectl set-timezone "$tz"
      '';
    in
    [
      backup # Backup with restic or rsync
      develop # Quickly copy and start dev template
      configure # Configure this flake config
      date-edit # Open text files, prepend current date to the first one
      drive # Rclone sync to drive (like proton)
      extract # Extract any compressed file
      inhibit # Quickly inhibit sleep, idle, shutdown
      smart-commit # Quickly commit or amend, lint message
      smart-terminal # Open a terminal quickly with first parameter always cd
      typst-compile # Compile the latest edited Typst file in current dir
      usb-mount # Quickly mount or unmount a USB device in ~/usb
      ripgrep-all # ripgrep for non-text files
      trash-cli # Manage a trash from CLI, used in scripts, not nush
      timezone # Set timezone according to IP geolocation
      # inshellisense # Command line autocomplete
      # rust-script # Use Rust in single file scripts
      # teamtype # Local text file collaboration
    ];

  home = {
    sessionVariables.PAGER = "${pkgs.ov}/bin/ov";
    shell = {
      enableShellIntegration = false; # Only for the following
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };

  programs = {
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
    broot.settings = {
      default_flags = "g"; # Git
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
    };
  };

  xdg.configFile = {
    "backup".source = ./script/backup;
    "commitlintrc.yaml".source = ./commitlintrc.yaml;
    "ov/config.yaml".source = ./ov.yaml;
    "tio/config".source = ./tio.ini;
  };
}
