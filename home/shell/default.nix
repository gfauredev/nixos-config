{ lib, pkgs, ... }: {
  imports = [ ./alias.nix ./nushell ./zsh.nix ./pulsemixer ];

  home.packages = let
    # TODO cleaner w/ nix module (DUPLICATED ../../tool/wezterm/info.nix)
    smart-terminal = let
      term = rec {
        name = "ghostty"; # Name of the terminal (for matching)
        cmd = name; # Launch terminal
        exec = "-e"; # Option to execute a command in place of shell
        cd = ""; # FIXME Option to launch terminal in a directory
        # Classed terminals (executes a command)
        monitoring = "wezterm start --class monitoring"; # FIXME hyprctl
        note = "wezterm start --class note"; # Note
        menu =
          "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
      };
    in pkgs.writeScriptBin "t" ''
      ${lib.readFile ./script/smart-terminal.sh}
      echo "Running: ${term.cmd} ${term.cd} $wd $cmd & disown"
      ${term.cmd} ${term.cd} "$wd" ${term.exec} "$cmd" & disown
      sleep 0.5
    '';
    extract = pkgs.writeScriptBin "ex" "${lib.readFile ./script/extract.sh}";
    backup = pkgs.writeScriptBin "back" "${lib.readFile ./script/backup.sh}";
    configure =
      pkgs.writeScriptBin "cfg" "${lib.readFile ./script/configure.sh}";
    smart-commit = pkgs.writeScriptBin "cmt" "${lib.readFile ./script/cmt.sh}";
    date-edit = pkgs.writeScriptBin "de" "${lib.readFile ./script/de.sh}";
    # inhib = pkgs.writeScriptBin "inhib" "${lib.readFile ./script/inhib.sh}";
    mkdir-cd = pkgs.writeScriptBin "md" "${lib.readFile ./script/md.sh}";
    present-pdf =
      pkgs.writeScriptBin "present" "${lib.readFile ./script/present.sh}";
    open = pkgs.writeScriptBin "open" "${lib.readFile ./script/open.sh}";
    typst-compile = pkgs.writeScriptBin "typ" "${lib.readFile ./script/typ.sh}";
    usb-mount = pkgs.writeScriptBin "usb" "${lib.readFile ./script/usb.sh}";
    usb-umount =
      pkgs.writeScriptBin "unusb" "${lib.readFile ./script/unusb.sh}";
  in with pkgs; [
    # Custom scripts
    smart-terminal # Open a terminal quickly with first parameter always cd
    extract # Extract any compressed file
    backup # Backup with restic or rsync
    configure # Configure this flake config
    smart-commit # Quickly commit or amend, lint message
    date-edit # Open text files, prepend current date to the first one
    mkdir-cd # Create dir(s) and cd into the first one
    present-pdf # Open detached pdfpc to present a PDF slide
    open # xdg-open from the CLI
    typst-compile # Compile the latest edited Typst file in current dir
    usb-mount # Quickly mount a USB device in ~/usb
    usb-umount # Quickly unmount USB device(s) mounted in ~/usb
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
    uv # Python package and project manager
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
    starship = {
      enable = true; # Super prompt
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
    eza = {
      enable = true; # Better ls
      enableNushellIntegration = false; # TEST seems to break the very nu logic
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
    bat = {
      enable = true; # Better cat with syntax highlighting
      # config.pager = "less -i"; # TODO setup ov
    };
    atuin = {
      enable = true; # TODO configure
      enableNushellIntegration = true;
    };
    zellij = {
      enable = true; # Terminal workspace and multiplexer
      enableZshIntegration = true;
      # See https://zellij.dev/documentation 
      # settings = { }; # TODO
    };
    # nix-your-shell = {
    #   enable = true; # Not needed, `direnv` does it
    #   enableNushellIntegration = true;
    # };
    gh = {
      enable = true; # GitHub official CLI
      # settings = { }; # TODO + credentials
    };
    gh-dash.enable = true; # GitHub dashboard
    jq.enable = true; # JSON parsing and request tool
    command-not-found.enable = true; # FIXME maybe shell config’s fault
    translate-shell.enable = true; # Google Translate CLI
    fd.enable = true; # Better find
    ripgrep.enable = true; # Better grep
    bottom.enable = true; # Better top
    fastfetch.enable = true; # Quick system info
    fzf = {
      enable = true; # Fuzzy searcher
      enableZshIntegration = true;
    };
    less = {
      enable = false; # Bugged, don’t use lesskeys
      keys = ''
        #command
        t forw-line
        s back-line
        T forw-line-force
        S back-line-force
      '';
    };
    lesspipe.enable = false;
  };

  xdg.configFile = { "ov/config.yaml" = { source = ./ov.yaml; }; };
}
