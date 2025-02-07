{ lib, pkgs, ... }: {
  imports = [ ./alias.nix ./pulsemixer ];

  home.packages = let
    term = # TODO this cleaner (import ../../tool/wezterm/info.nix)
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
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
    # TEST revelance of each options below # TODO improve, cleaner
    completionInit = ''
      autoload -Uz compinit && compinit -i && _comp_options+=(globdots)

      zstyle ':completion:*' completer _complete _approximate _expand_alias
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      zstyle ':completion:*' menu select
      zmodload zsh/complist

      bindkey -M menuselect 'c' vi-backward-char
      bindkey -M menuselect 't' vi-down-line-or-history
      bindkey -M menuselect 's' vi-up-line-or-history
      bindkey -M menuselect 'r' vi-forward-char

      bindkey -M vicmd 'c' vi-backward-char
      bindkey -M vicmd 't' history-beginning-search-forward
      bindkey -M vicmd 's' history-beginning-search-backward
      bindkey -M vicmd 'r' vi-forward-char
    '';
    defaultKeymap = "viins";
    # FIXME
    # dotDir = "${config.home-manager.users.gf.home.sessionVariables.XDG_CONFIG_HOME}/zsh";
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignorePatterns = [ ];
      ignoreSpace = true;
      path = "$ZDOTDIR/history"; # FIXME make this dependant on above
      size = 12420;
      share = true;
    };
    historySubstringSearch.enable = true;
    initExtra = builtins.readFile ./zshrc.sh; # TODO this cleaner
  };

  programs.nushell = {
    enable = true; # TODO configure
    # See : https://www.nushell.sh/book/getting_started.html
    # configFile.source = ./config.nu;
    # envFile.source = ./env.nu;
    # loginFile.source = ./login.nu;
  };

  programs = {
    broot = { # TODO organize
      enable = true; # Quick fuzzy file finder
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        default_flags = "dgps";
        special_paths = lib.mkForce { };
      };
    };
    yazi = { # TODO organize
      enable = true; # TODO configure
      #   keymap = {
      #     input.prepend_keymap = [
      #       {
      #         run = "close";
      #         on = [ "<C-q>" ];
      #       }
      #       {
      #         run = "close --submit";
      #         on = [ "<Enter>" ];
      #       }
      #       {
      #         run = "escape";
      #         on = [ "<Esc>" ];
      #       }
      #       {
      #         run = "backspace";
      #         on = [ "<Backspace>" ];
      #       }
      #     ];
      #     manager.prepend_keymap = [
      #       {
      #         run = "escape";
      #         on = [ "<Esc>" ];
      #       }
      #       {
      #         run = "quit";
      #         on = [ "q" ];
      #       }
      #       {
      #         run = "close";
      #         on = [ "<C-q>" ];
      #       }
      #     ];
      #   };
    };
    translate-shell.enable = true; # Google Translate CLI
    command-not-found.enable =
      false; # FIXME doesn’t work (maybe due to shell config)
    eza = {
      enable = true; # Better ls
      enableNushellIntegration = true; # TODO for other programs
    };
    fd.enable = true; # Better find
    ripgrep.enable = true; # Better grep
    bottom.enable = true; # Better top
    fastfetch.enable = true; # Quick system info
    zoxide = {
      enable = true; # Smart cd
      enableZshIntegration = true;
    };
    starship = {
      enable = true; # Super prompt
      enableZshIntegration = true;
      settings = {
        character = {
          format = "$symbol ";
          # success_symbol = "[☭](bold green)";
          # error_symbol = "[\\$](bold red)";
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
      enableZshIntegration = true;
    };
  };

  xdg.configFile = { "ov/config.yaml" = { source = ./ov.yaml; }; };
}
