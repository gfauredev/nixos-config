{ lib, pkgs, ... }: {
  imports = [ ./alias.nix ./xonsh.nix ./nushell ./zsh.nix ./pulsemixer ];

  home.packages = let
    init-dev-env =
      pkgs.writeScriptBin "dev" "${lib.readFile ./script/init-dev-env.sh}";
    smart-terminal =
      pkgs.writeScriptBin "t" "${lib.readFile ./script/smart-terminal.sh}";
    extract = pkgs.writeScriptBin "ex" "${lib.readFile ./script/extract.sh}";
    backup = pkgs.writeScriptBin "back" "${lib.readFile ./script/backup.sh}";
    clean-archive = pkgs.writeScriptBin "cleanarchive"
      "${lib.readFile ./script/clean-archive.sh}";
    configure =
      pkgs.writeScriptBin "configure" "${lib.readFile ./script/configure.sh}";
    smart-commit =
      pkgs.writeScriptBin "cmt" "${lib.readFile ./script/smart-commit.sh}";
    date-edit =
      pkgs.writeScriptBin "de" "${lib.readFile ./script/date-edit.sh}";
    present-pdf =
      pkgs.writeScriptBin "present" "${lib.readFile ./script/present.sh}";
    xdg-open = pkgs.writeScriptBin "xopen" "${lib.readFile ./script/open.sh}";
    typst-compile = pkgs.writeScriptBin "typ" "${lib.readFile ./script/typ.sh}";
    usb-mount = pkgs.writeScriptBin "mount-usb" "${lib.readFile ./script/usb.sh}";
    mtp-mount = pkgs.writeScriptBin "mount-mtp" "${lib.readFile ./script/mtp.sh}";
  in with pkgs; [
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
    xdg-open # xdg-open from the CLI
    typst-compile # Compile the latest edited Typst file in current dir
    usb-mount # Quickly mount or unmount a USB device in ~/usb
    mtp-mount # Quickly mount or unmount Android device(s) mounted in ~/mtp
    # Development and general CLI tools
    ov # Modern pager
    trash-cli # Manage a trash from CLI
    ripgrep-all # ripgrep for non-text files
    duf # global disk usage
    du-dust # detailed disk usage of a directory
    hexyl # hex viever
    sd # Intuitive find & replace
    grex # Regex generator from test cases
    moreutils # Additional Unix utilities
    # rustdesk # Modern remote desktop
    kalker # Evaluate math expression
    nixpkgs-review # Quickly review pull requests to nixpkgs TEST
    comma # Run any command from Nixpkgs
    steam-run # Run in isolated FHS
    manix # Nix documentation CLI
    watchexec # Run command when file changes
    hyperfine # Benchmark commands
    nickel # Modern configuration Nickel, Nix improvement
    cdrkit # ISO tools and misc
    browsh # 6ixel CLI web browser
    pipectl # Named pipes management
    # Git
    gitlab-shell # GitLab CLI
    commitlint-rs # Be consistent in commit messages
  ];

  home.shell.enableShellIntegration = true;

  programs = {
    fd.enable = true; # Better find
    ripgrep.enable = true; # Better grep
    bat.enable = true; # Better cat with syntax highlighting
    bottom.enable = true; # Better top
    starship = {
      enable = true; # Super prompt
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true; # Smart cd
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
    broot = { # TODO organize
      enable = true; # Quick fuzzy file finder
      enableNushellIntegration = true;
      enableZshIntegration = true;
      settings = {
        default_flags = "dgps";
        special_paths = lib.mkForce { }; # Remove them
        verbs = [{
          invocation = "edit";
          key = "enter";
          shortcut = "e";
          external = "$EDITOR {file}:{line}";
          apply_to = "text_file";
          leave_broot = false;
          set_working_dir = true;
        }];
      };
    };
    atuin = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        enter_accept = true; # Don’t currently work on Nushell
        workspaces = true; # Filter commands executed in Git repo
        ctrl_n_shortcuts = true; # Ctrl+[1-9] quickly select cmd
        # filter_mode_shell_up_key_binding = "session";
      };
    };
    eza = {
      enable = true; # Better ls
      enableNushellIntegration = false;
      enableZshIntegration = true;
    };
    gh = {
      enable = true; # GitHub official CLI
      # settings = { }; # TODO + credentials
    };
    gh-dash.enable = true; # GitHub dashboard
    jq.enable = true; # JSON parsing and request tool
    translate-shell.enable = true; # Google Translate CLI
    fastfetch.enable = true; # Quick system info
    less.enable = false; # Bugged, don’t respects lesskeys
    lesspipe.enable = false;
  };

  xdg.configFile = {
    "ov/config.yaml".source = ./ov.yaml;
    "commitlintrc.yaml".source = ./commitlintrc.yaml;
    "backup-exclude".source = ./script/backup-exclude;
  };
}
