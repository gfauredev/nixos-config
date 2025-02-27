{ lib, pkgs, ... }: {
  imports = [ ./alias.nix ./pulsemixer ];

  home.packages = let
    term = # TODO this cleaner (import ../../tool/wezterm/info.nix) duplicated
      {
        name = "wezterm"; # Name of the terminal (for matching)
        cmd = "wezterm start"; # Launch terminal
        # cmd = "wezterm start --always-new-process"; # FIX when too much terms crash
        exec = ""; # Option to execute a command in place of shell
        cd = "--cwd"; # Option to launch terminal in a directory
        # Classed terminals (executes a command)
        monitoring = "wezterm start --class monitoring"; # Monitoring
        note = "wezterm start --class note"; # Note
        menu =
          "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
      };
    smart-terminal = pkgs.writeScriptBin "t" ''
      #!/bin/sh
      wd=$PWD
      cmd="$SHELL"
      if [ -n "$1" ] && $SHELL -ic which "$1"; then
        cmd="$cmd -ic $*"
      elif [ -d "$1" ]; then
        wd="$1"
        shift
        if [ -n "$1" ] && $SHELL -ic which "$1"; then
          cmd="$cmd -ic $*"
        fi
      fi
      echo "Running: ${term.cmd} ${term.cd} $wd $cmd & disown"
      ${term.cmd} ${term.cd} "$wd" ${term.exec} "$cmd" & disown
      sleep 0.5
    '';
    extract = pkgs.writeScriptBin "ex" "${lib.readFile ./extract.sh}";
    backup = pkgs.writeScriptBin "back" "${lib.readFile ./back.sh}";
    configure = pkgs.writeScriptBin "cfg" "${lib.readFile ./configure.sh}";
  in with pkgs; [
    smart-terminal # Open a terminal quickly with first parameter always cd
    extract # Extract any compressed file
    backup # Backup with restic or rsync
    configure # Configure this flake config
    ov # Modern pager
    trash-cli # Manage a trash from CLI
    ripgrep-all # ripgrep for non-text files
    duf # global disk usage
    du-dust # detailed disk usage of a directory
    imhex # Powerful hex editor
    hexyl # hex viever
    sd # Intuitive find & replace
    grex # Regex generator from test cases
    superfile # Fancy CLI file manager TEST
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./zshrc.sh; # TODO this cleaner
    sessionVariables.SHELL = "$(which zsh)"; # Set interactive shell
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignorePatterns = [ ];
      ignoreSpace = true;
      path = "$XDG_DATA_HOME/zsh_history";
      size = 30000;
      share = true;
    };
    historySubstringSearch.enable = true;
  };

  # TODO separate files for each shell
  programs.nushell = {
    enable = true; # TODO configure and TEST
    # See : https://www.nushell.sh/book/getting_started.html
    # configFile.source = ./config.nu;
    # envFile.source = ./env.nu;
    # loginFile.source = ./login.nu;
  };

  # programs.xonsh = {
  #   enable = true; # Shell which is a superset of Python
  # };

  programs = {
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
    translate-shell.enable = true; # Google Translate CLI
    command-not-found.enable = false; # FIXME maybe shell config’s fault
    eza = {
      enable = true; # Better ls
      enableNushellIntegration = false; # TEST seems to break the very nu logic
      enableZshIntegration = true;
    };
    fd.enable = true; # Better find
    ripgrep.enable = true; # Better grep
    bottom.enable = true; # Better top
    fastfetch.enable = true; # Quick system info
    zoxide = {
      enable = true; # Smart cd
      # enableNushellIntegration = true; # TODO
      enableZshIntegration = true;
    };
    starship = {
      enable = true; # Super prompt
      enableNushellIntegration = true;
      enableZshIntegration = true;
      settings = {
        character = {
          format = "$symbol ";
          vimcmd_symbol = "[N](bold blue)";
          vimcmd_replace_one_symbol = "[r](bold blue)";
          vimcmd_replace_symbol = "[R](bold blue)";
          vimcmd_visual_symbol = "[V](bold blue)";
        };
      };
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
    bat = {
      enable = true; # Better cat with syntax highlighting
      # config.pager = "less -i"; # TODO set ov
    };
    fzf = {
      enable = true; # Fuzzy searcher
      # enableNushellIntegration = true; # TODO
      enableZshIntegration = true;
    };
  };

  xdg.configFile = { "ov/config.yaml" = { source = ./ov.yaml; }; };
}
